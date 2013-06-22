Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab3FVSyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 14:54:52 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:48352
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077Ab3FVSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 14:54:51 -0400
Message-Id: <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
In-Reply-To: Message from Greg KH <gregkh@linuxfoundation.org>
   of "Fri, 21 Jun 2013 16:56:03 -0700." <20130621235603.GA1603@kroah.com>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se> <20130619225315.GB12282@kroah.com> <201306212308.r5LN8C7M020720@eskarina.iko.pp.se><20130621235603.GA1603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13880.1371927283.1@eskarina.iko.pp.se>
Date: Sat, 22 Jun 2013 20:54:43 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Sat, 22 Jun 2013 20:54:45 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Fri, 21 Jun 2013 16:56:03 -0700, Greg KH writes:
>Please resend this in a format that I can apply it in (i.e. one that
>does not require me to edit it by hand...)

After more fighting with git, I belive I now made it spit out what I
wanted. Patch 1/2 ahead.

>> -static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
>> +static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {
>
>That's a mess, why have it be a static array at all?  Just include an
>empty one at the end.

Indeed. I'd already had some (failed) thoughts about how to handle it
nicely. Now I've had another think through, and I have something which
deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
without changing the initializer. Patch 2/2

/Anders
