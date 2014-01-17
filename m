Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaAQNef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:34:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36612 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaAQNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:34:32 -0500
Date: Fri, 17 Jan 2014 14:34:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH] Bluetooth: add module name for btwilink
Message-ID: <20140117133430.GC15496@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140110145207.GB12048@amd.pavel.ucw.cz>
 <20140111002801.GA20216@amd.pavel.ucw.cz>
 <FD05FD52-1502-4AB8-8650-FC785B700088@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FD05FD52-1502-4AB8-8650-FC785B700088@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btwilink help did not include module name, add it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 11a6104..f5ce64e 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -241,5 +241,6 @@ config BT_WILINK
 	  core driver to communicate with the BT core of the combo chip.
 
 	  Say Y here to compile support for Texas Instrument's WiLink7 driver
-	  into the kernel or say M to compile it as module.
+	  into the kernel or say M to compile it as module (btwilink).
+
 endmenu

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
