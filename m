Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3FZIaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:30:11 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:52975
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841Ab3FZIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:30:05 -0400
Message-Id: <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
In-Reply-To: Message from Greg KH <gregkh@linuxfoundation.org>
   of "Tue, 25 Jun 2013 16:39:11 -0700." <20130625233911.GA1087@kroah.com>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se> <20130619225315.GB12282@kroah.com> <201306212308.r5LN8C7M020720@eskarina.iko.pp.se> <20130621235603.GA1603@kroah.com> <201306221854.r5MIshv5013882@eskarina.iko.pp.se><20130625233911.GA1087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3879.1372235399.1@eskarina.iko.pp.se>
Date: Wed, 26 Jun 2013 10:29:59 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Wed, 26 Jun 2013 10:30:00 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Tue, 25 Jun 2013 16:39:11 -0700, Greg KH writes:
>> Indeed. I'd already had some (failed) thoughts about how to handle it
>> nicely. Now I've had another think through, and I have something which
>> deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
>> without changing the initializer. Patch 2/2
>
>Why don't we just drop the extra id thing entirely?  The usb-serial
>subsystem handles new device ids being added dynamically from sysfs for
>a long time now.  Removing this module option would clean up the code a
>lot, and prevent these errors from ever happening again.

Aha, yes, I'm all for that (had I only known I'd have done that to start
with). I'll look in to it.

/Anders
