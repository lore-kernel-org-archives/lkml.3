Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3GYOQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:16:02 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:50714
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755457Ab3GYOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:15:57 -0400
Message-Id: <201307251415.r6PEFoO1015986@eskarina.iko.pp.se>
X-Face: ^"+mumOlNwo;yI>`\39\txuVze?eiR9uqpo2*mE!9MWXgXI0v(3ArwymNWe'.q:eLl!=guD
 x{jGFEWN6,#HoN%2qRW;7.CL]9%Ap,067"u1%!NUqS.MhV'+,6$Fj-;W2Z}Y,JUZ'L+f<?~E{ID*=T
 V\NxAOu>)|B@3k3n;gLl*#i[(J-os#fNnDJ8m["|JWNwpORh|_.MGkR#|a~QS!"4hEQ{O{[Ii14{xD
 PU/:5wuv7m1=TK=.>G8wdfpY~]{H(Qa\1`%|Hz:!)c3f9UOW|WgE"4d\E7?oDu9.
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] Remove static sizing of usb_device_id arrays
In-Reply-To: Message from Greg KH <gregkh@linuxfoundation.org>
   of "Wed, 24 Jul 2013 15:52:08 -0700." <20130724225208.GA3140@kroah.com>
References: <20130621235603.GA1603@kroah.com> <1371927359-13977-1-git-send-email-iko@iko.pp.se> <1371927359-13977-2-git-send-email-iko@iko.pp.se><20130724225208.GA3140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15984.1374761749.1@eskarina.iko.pp.se>
Date: Thu, 25 Jul 2013 16:15:49 +0200
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Thu, 25 Jul 2013 16:15:52 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a message of Wed, 24 Jul 2013 15:52:08 -0700, Greg KH writes:
>On Sat, Jun 22, 2013 at 08:55:59PM +0200, Anders Hammarquist wrote:
>> 
>> Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
>> ---
>>  drivers/usb/serial/ti_usb_3410_5052.c |   29 ++++++++++++++++++++++++-----
>>  1 file changed, 24 insertions(+), 5 deletions(-)
>
>This patch, and your previous one, are no longer needed, right?

They are needed until the module params for adding vendor and
product ids are removed, and it sounded like the consensus was
to keep them for a while.

/Anders
