Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbaLKJRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:17:25 -0500
Received: from palmtree.beeroclock.net ([178.79.160.154]:54884 "EHLO
	palmtree.beeroclock.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaLKJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:17:23 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2014 04:17:22 EST
Content-Type: multipart/mixed; boundary="===============1864634074=="
MIME-Version: 1.0
Subject: Re: Re: [PATCH] USB: serial: add nt124 usb to serial driver
From: Karl Palsson <karlp@tweak.net.au>
To: "Johan Hovold" <johan@kernel.org>
Cc: "George McCollister" <george.mccollister@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
In-Reply-To: <20141210130412.GJ14346@localhost>
References: <20141210130412.GJ14346@localhost>
Date: Thu, 11 Dec 2014 09:05:30 -0000
Message-Id: <20141211085947-31703-27980-mailpile@palmtree-beeroclock-net>
OpenPGP: id=B906EA4B8A2815C4F8596F9F47C13F3FED735179; preference=signencrypt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1864634074==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Johan Hovold <johan@kernel.org> wrote:
> On Mon, Dec 08, 2014 at 05:24:17PM -0600, George McCollister wrote:

> > +	newline.bParityType = termios->c_cflag & PARENB ?
> > +				(termios->c_cflag & PARODD ? 1 : 2) +
> > +				(termios->c_cflag & CMSPAR ? 2 : 0) : 0;
> 
> This hardly readable. Don't use ?:
> 

There's also C_PARENB(tty),  C_PARODD(tty), and C_CMSPAR(tty) macros
available, in addition to the others that Johan pointed out.

Sincerely,
Karl P
--===============1864634074==--

