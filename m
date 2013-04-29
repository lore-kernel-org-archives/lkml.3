Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab3D2VQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:16:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab3D2VQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:16:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Date: Mon, 29 Apr 2013 23:16:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
References: <20130429162115.GA6893@kroah.com> <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com> <8yafvy92gfs.fsf@huya.qualcomm.com>
In-Reply-To: <8yafvy92gfs.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304292316.28464.arnd@arndb.de>
X-Provags-ID: V02:K0:nfjmFM7O9y2ccqQabf+C/2z12N1U585l38lmgux1UTx
 lwNyU1HpiKZqx59OIqd+r1o60YBUAQGvqm2aHkGhSag6c4AGwh
 oH73nPcGVCXf+YxUVU4l9QuIdy61S0ygXVZ9XVL55TPt0m2uxg
 /vRsoWI/wGSVDG8wC+xaSNzXyvFSMJ1pU3Q2ejI+2NjqJxIOxm
 E2k12NzLIdTwP0sbDC52xEJesHPuRgxxqBrtr2B6VY+/+h++cn
 cz4mN4F1DVehLDpWkaMQ3G4FY6CxSqRuyv+TKt0hPDsGyrUD+/
 nfBqpXHdCq+VC80cI15wmJg1qtnIXvzOOBvFEzudYC5gK7Bof7
 PvJUwLrioivq27lzQ2GM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013, David Brown wrote:
> I'm not sure why this shouldn't be in the drivers/mfd directory
> alongside the various pm*.c drivers that use it.  It isn't going to be
> used for anything else.
> 
> Given the bikeshedding that happened when Ken pushed the driver out last
> time, though, I'm sure this will create a firestorm of disagreement over
> its location.

Well, the only reason I see against putting it into drivers/mfd is that
this place is becoming a dumping ground for stuff that doesn't have a
real home anywhere else. On the other hand, this one would fit better
than a lot of drivers that are already there, and it would actually remove
the need for a global include/linux/*.h header file as the interface.

	Arnd
