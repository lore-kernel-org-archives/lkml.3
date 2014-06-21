Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbaFUBWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 21:22:32 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36137 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbaFUBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 21:22:31 -0400
MIME-Version: 1.0
Date: Sat, 21 Jun 2014 09:22:30 +0800
Message-ID: <CAJKoSVRC2s7VzX9hmf9-x3Qseuh+i7Fasz+x4-b33NNvod3yUw@mail.gmail.com>
Subject: [PATCH] staging: ft1000_dnld.c:code indent should use tabs where possible
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issue in
ft1000/ft1000-pcmcia/ft1000_dnld.c
ERROR: code indent should use tabs where possible

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index d44e858..afaab07 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -15,8 +15,8 @@
    Suite 330, Boston, MA 02111-1307, USA.
   --------------------------------------------------------------------------

-   Description:  This module will handshake with the DSP bootloader to
-                 download the DSP runtime image.
+   Description: This module will handshake with the DSP bootloader to
+		download the DSP runtime image.

 ---------------------------------------------------------------------------*/

-- 
1.7.9.5
