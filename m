Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3FZIXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:23:39 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:52964
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751344Ab3FZIXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:23:36 -0400
Message-Id: <201306260821.r5Q8LM18003679@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [07/26] USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
In-Reply-To: Message from Ben Hutchings <ben@decadent.org.uk>
   of "Wed, 26 Jun 2013 03:35:58 +0100." <lsq.1372214158.308371705@decadent.org.uk>
References: <lsq.1372214158.308371705@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3677.1372234882.1@eskarina.iko.pp.se>
Date: Wed, 26 Jun 2013 10:21:22 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Wed, 26 Jun 2013 10:21:26 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Wed, 26 Jun 2013 03:35:58 +0100, Ben Hutchings writes:
>3.2.48-rc1 review patch.  If anyone has any objections, please let me know.
>
>------------------
>
>From: Anders Hammarquist <iko@iko.pp.se>
>
>commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.
>
>Add product id for Abbott strip port cable for Precision meter which
>uses the TI 3410 chip.

It needs to be paired with later patches that fix the statically sized
usb_device_id array, so I don't think it should go in alone.

/Anders 
