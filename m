Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FYVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:39:41 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:52499
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054Ab3FYVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:39:39 -0400
Message-Id: <201306252139.r5PLdQpP017104@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 17/17] USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
In-Reply-To: Message from Greg Kroah-Hartman <gregkh@linuxfoundation.org>
   of "Tue, 25 Jun 2013 11:39:32 -0700." <20130625183917.373592561@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org><20130625183917.373592561@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17102.1372196366.1@eskarina.iko.pp.se>
Date: Tue, 25 Jun 2013 23:39:26 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Tue, 25 Jun 2013 23:39:30 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Tue, 25 Jun 2013 11:39:32 -0700, Greg Kroah-Hartman writes:
>3.0-stable review patch.  If anyone has any objections, please let me know.
>
>From: Anders Hammarquist <iko@iko.pp.se>
>
>commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.
>
>Add product id for Abbott strip port cable for Precision meter which
>uses the TI 3410 chip.

Given the statically sized arrays, I think this patch should not go in
alone. It needs to go together with the later patches I sent you that
fix the array sizing.

(this applies to all trees)

/Anders
