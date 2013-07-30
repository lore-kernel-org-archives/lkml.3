Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3G3PSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54993 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030Ab3G3PSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:00 -0400
Message-ID: <1375197479.2075.116.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: USB, remove F: drivers/net/usb/ pattern
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Date: Tue, 30 Jul 2013 08:17:59 -0700
In-Reply-To: <20130730135828.GD27962@kroah.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
	 <1375172936-4145-1-git-send-email-hayeswang@realtek.com>
	 <20130730135828.GD27962@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 06:58 -0700, Greg KH wrote:

> In the future, you do not need to send drivers/net/usb/ patches to me,
> netdev and the linux-usb mailing lists should be sufficient.

Signed-off-by: Joe Perches <joe@perches.com>
---

This might help...

diff --git a/MAINTAINERS b/MAINTAINERS
index 339e798..9b5335a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8780,7 +8780,6 @@ W:	http://www.linux-usb.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
 S:	Supported
 F:	Documentation/usb/
-F:	drivers/net/usb/
 F:	drivers/usb/
 F:	include/linux/usb.h
 F:	include/linux/usb/


