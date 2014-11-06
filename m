Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaKFXZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:25:10 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41891 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbaKFXZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:25:05 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kris@konagma.com
Subject: [PATCH 1/3] rtl8188eu: Fix FSF_MAILING_ADDRESS in rtw_led.*
Date: Fri,  7 Nov 2014 00:24:26 +0100
Message-Id: <1415316268-10278-1-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_led.* files include Free Software Foundation's mailing address in
the sample GPL notice.  This is not desired and picked when running
scripts/checkpatch.pl.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c    | 4 ----
 drivers/staging/rtl8188eu/include/rtw_led.h | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index 2aa6251..c6e8379 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  *
  ******************************************************************************/
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index dec8dbc..c49a9a1 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -11,10 +11,6 @@
  * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  * more details.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
  *
  ******************************************************************************/
 #ifndef __RTW_LED_H_
-- 
2.1.1

