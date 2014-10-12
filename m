Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaJLL7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:59:47 -0400
Received: from CPE-121-211-193.123.hhui7.cht.bigpond.net.au ([121.211.193.123]:40829
	"EHLO smtp.alterapraxis.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbaJLL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:59:45 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 07:59:45 EDT
Date: Sun, 12 Oct 2014 22:53:43 +1100
From: "Edward O'Callaghan" <eocallaghan@alterapraxis.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86/kernel/rtc.c: Overzealous usage of 'const' keyword
Message-ID: <20141012225343.0bb95e1c.eocallaghan@alterapraxis.com>
Organization: Altera Praxis Pty Ltd
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ne7vKi+ncwnDWqhQrXgTf51"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/ne7vKi+ncwnDWqhQrXgTf51
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please merge.


-- 
______________________________________________________________________

Edward O'Callaghan, Director and Principal consultant.

https://www.alterapraxis.com | eocallaghan@alterapraxis.com

Altera Praxis Pty Ltd,  // Discretions in cybersecurity
ACN 165 424 064.       // reconnaissance and adversary mitigation.
______________________________________________________________________

--MP_/ne7vKi+ncwnDWqhQrXgTf51
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-arch-x86-kernel-rtc.c-Overzealous-usage-of-const-key.patch

=46rom f8847c4eb8f7550c43e2dbc9efaff91434a54fe7 Mon Sep 17 00:00:00 2001
From: Edward O'Callaghan <eocallaghan@alterapraxis.com>
Date: Sun, 12 Oct 2014 22:25:40 +1100
Subject: [PATCH] arch/x86/kernel/rtc.c: Overzealous usage of 'const' keyword
Organization: Altera Praxis Pty Ltd.
To: linux-kernel@vger.kernel.org

No need to qualify with 'const' no less than three times over.

Signed-off-by: Edward O'Callaghan <eocallaghan@alterapraxis.com>
---
 arch/x86/kernel/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..75cf16a 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -170,7 +170,7 @@ static struct platform_device rtc_device =3D {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char * const  const ids[] __initconst =3D
+	static const char * ids[] __initconst =3D
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
--=20
2.1.2


--MP_/ne7vKi+ncwnDWqhQrXgTf51--
