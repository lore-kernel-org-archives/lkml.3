Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3JWOCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:02:22 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:43408 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3JWOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:02:21 -0400
Date: Wed, 23 Oct 2013 15:57:47 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Lunn <andrew@lunn.ch>, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, jhovold@gmail.com
Subject: Re: [PATCH] tty: Add C_MSPAR(tty)
Message-ID: <20131023135747.GD31126@lunn.ch>
References: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
 <5267D386.4050206@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267D386.4050206@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:47:50AM -0400, Peter Hurley wrote:
> On 10/23/2013 07:18 AM, Andrew Lunn wrote:
> >Add the missing C_MSPAR(tty) macro.
> >
> >Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> >---
> >  include/linux/tty.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/include/linux/tty.h b/include/linux/tty.h
> >index 64f8646..630678d 100644
> >--- a/include/linux/tty.h
> >+++ b/include/linux/tty.h
> >@@ -137,6 +137,7 @@ struct tty_bufhead {
> >  #define C_CLOCAL(tty)	_C_FLAG((tty), CLOCAL)
> >  #define C_CIBAUD(tty)	_C_FLAG((tty), CIBAUD)
> >  #define C_CRTSCTS(tty)	_C_FLAG((tty), CRTSCTS)
> >+#define C_MSPAR(tty)	_C_FLAG((tty), CMSPAR)
> >
> >  #define L_ISIG(tty)	_L_FLAG((tty), ISIG)
> >  #define L_ICANON(tty)	_L_FLAG((tty), ICANON)
> 
> Is this to support an out-of-tree driver?

Hi Peter

It is to support a driver i'm trying to get accepted. It is a USB
serial driver which was posted for the forth time today to the USB
list:

http://article.gmane.org/gmane.linux.usb.general/96740

   Andrew
