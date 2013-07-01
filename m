Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3GAXWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 19:22:19 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:58769
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753736Ab3GAXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 19:22:17 -0400
Message-Id: <201307012322.r61NM1vv019204@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Johan Hovold <jhovold@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
In-Reply-To: Message from Johan Hovold <jhovold@gmail.com>
   of "Fri, 28 Jun 2013 12:23:33 +0200." <20130628102333.GA13241@localhost>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se> <20130619225315.GB12282@kroah.com> <201306212308.r5LN8C7M020720@eskarina.iko.pp.se> <20130621235603.GA1603@kroah.com> <201306221854.r5MIshv5013882@eskarina.iko.pp.se> <20130625233911.GA1087@kroah.com> <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se> <20130626103924.GA30828@localhost> <201306272150.r5RLoq2u006119@eskarina.iko.pp.se><20130628102333.GA13241@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19202.1372720921.1@eskarina.iko.pp.se>
Date: Tue, 02 Jul 2013 01:22:01 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Tue, 02 Jul 2013 01:22:05 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Fri, 28 Jun 2013 12:23:33 +0200, Johan Hovold writes:
>> I did a quick check of adding the device id though sysfs, and although
>> it partly works, it doesn't find the correct firmware (it ends up trying
>> to load 5052 firmware for a 3410 device. Looking at the code it seems
>> (struct ti_device) td_is_3410 isn't set properly.)
>
>Turns out that the drivers device-type detection has never worked with
>the dynamic id interface (all devices were detected as 2-port devices).
>
>I'm responding to this mail with a fix. Care to give it a try?

Yes, this works fine. 

/Anders
