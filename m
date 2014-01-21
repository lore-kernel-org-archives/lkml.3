Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaAUVc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:32:57 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50800 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaAUVZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pcmcia@lists.infradead.org>
Subject: [PATCH 55/73] drivers/pcmcia: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:58 -0500
Message-ID: <1390339396-3479-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pcmcia@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pcmcia/bfin_cf_pcmcia.c    | 1 -
 drivers/pcmcia/electra_cf.c        | 1 -
 drivers/pcmcia/i82092.c            | 1 -
 drivers/pcmcia/pd6729.c            | 1 -
 drivers/pcmcia/pxa2xx_viper.c      | 1 -
 drivers/pcmcia/sa1100_assabet.c    | 1 -
 drivers/pcmcia/sa1100_cerf.c       | 1 -
 drivers/pcmcia/sa1100_h3600.c      | 1 -
 drivers/pcmcia/sa1100_nanoengine.c | 1 -
 drivers/pcmcia/sa1100_shannon.c    | 1 -
 drivers/pcmcia/sa1100_simpad.c     | 1 -
 drivers/pcmcia/sa1111_jornada720.c | 1 -
 drivers/pcmcia/sa1111_lubbock.c    | 1 -
 drivers/pcmcia/sa1111_neponset.c   | 1 -
 drivers/pcmcia/soc_common.c        | 1 -
 drivers/pcmcia/socket_sysfs.c      | 1 -
 drivers/pcmcia/vrc4171_card.c      | 1 -
 drivers/pcmcia/vrc4173_cardu.c     | 1 -
 18 files changed, 18 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index 971991b..38fba4b 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -30,7 +30,6 @@
 #include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 5ea64d0..aff5af2 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -25,7 +25,6 @@
 #include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 7d47456..032e115 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index 622dd6f..14ec899 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
diff --git a/drivers/pcmcia/pxa2xx_viper.c b/drivers/pcmcia/pxa2xx_viper.c
index a76f495..dc10637 100644
--- a/drivers/pcmcia/pxa2xx_viper.c
+++ b/drivers/pcmcia/pxa2xx_viper.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff --git a/drivers/pcmcia/sa1100_assabet.c b/drivers/pcmcia/sa1100_assabet.c
index 44cfc44..2ba4b9f 100644
--- a/drivers/pcmcia/sa1100_assabet.c
+++ b/drivers/pcmcia/sa1100_assabet.c
@@ -9,7 +9,6 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/gpio.h>
 
 #include <asm/mach-types.h>
diff --git a/drivers/pcmcia/sa1100_cerf.c b/drivers/pcmcia/sa1100_cerf.c
index b3774e5..ed65bbf 100644
--- a/drivers/pcmcia/sa1100_cerf.c
+++ b/drivers/pcmcia/sa1100_cerf.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 
diff --git a/drivers/pcmcia/sa1100_h3600.c b/drivers/pcmcia/sa1100_h3600.c
index 431d8b0..9cde70c 100644
--- a/drivers/pcmcia/sa1100_h3600.c
+++ b/drivers/pcmcia/sa1100_h3600.c
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 
diff --git a/drivers/pcmcia/sa1100_nanoengine.c b/drivers/pcmcia/sa1100_nanoengine.c
index 35c30ff..bf3fe92 100644
--- a/drivers/pcmcia/sa1100_nanoengine.c
+++ b/drivers/pcmcia/sa1100_nanoengine.c
@@ -22,7 +22,6 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/signal.h>
diff --git a/drivers/pcmcia/sa1100_shannon.c b/drivers/pcmcia/sa1100_shannon.c
index b07a2dc..eee7c00 100644
--- a/drivers/pcmcia/sa1100_shannon.c
+++ b/drivers/pcmcia/sa1100_shannon.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
diff --git a/drivers/pcmcia/sa1100_simpad.c b/drivers/pcmcia/sa1100_simpad.c
index 73fd379..f73e9d2 100644
--- a/drivers/pcmcia/sa1100_simpad.c
+++ b/drivers/pcmcia/sa1100_simpad.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/init.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
diff --git a/drivers/pcmcia/sa1111_jornada720.c b/drivers/pcmcia/sa1111_jornada720.c
index 3baa3ef..e0fd2c2 100644
--- a/drivers/pcmcia/sa1111_jornada720.c
+++ b/drivers/pcmcia/sa1111_jornada720.c
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 
 #include <mach/hardware.h>
 #include <asm/hardware/sa1111.h>
diff --git a/drivers/pcmcia/sa1111_lubbock.c b/drivers/pcmcia/sa1111_lubbock.c
index c5caf57..a19fb91 100644
--- a/drivers/pcmcia/sa1111_lubbock.c
+++ b/drivers/pcmcia/sa1111_lubbock.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 
 #include <mach/hardware.h>
diff --git a/drivers/pcmcia/sa1111_neponset.c b/drivers/pcmcia/sa1111_neponset.c
index 1d78739..d0bc44f 100644
--- a/drivers/pcmcia/sa1111_neponset.c
+++ b/drivers/pcmcia/sa1111_neponset.c
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a2bc6ee..3c25d2e 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -33,7 +33,6 @@
 
 #include <linux/cpufreq.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index d688151..4132815 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -10,7 +10,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/major.h>
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index d98a086..2f48f1b 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -17,7 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index d926920..a35a4f4 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -28,7 +28,6 @@
  *  with this program; if not, write to the Free Software Foundation, Inc.,
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-- 
1.8.4.1

