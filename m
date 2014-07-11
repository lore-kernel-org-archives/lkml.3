Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaGKONO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:13:14 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56647 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaGKONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <20385712.vl9ZPHu7Ll@indiana>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru>
 <20140710170954.GB23544@kroah.com> <CAJs94Eao-ujjZevjptf5hhmkS742HdUVafP4avHR3gx0WzuSTw@mail.gmail.com>
 <20385712.vl9ZPHu7Ll@indiana>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 11 Jul 2014 18:12:50 +0400
X-Google-Sender-Auth: FqbdPQYXjMEehtahoGJw0TQYnIE
Message-ID: <CAJs94EZgQR4Qhb3oX3v-voOi+8UCs61po=kj8SF7oeiWVRq0cw@mail.gmail.com>
Subject: Re: [Linux-parport] [PATCHv3 2/2] Add force_epp module option for parport_pc.
To: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
Cc: linux-parport <linux-parport@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Heiko Andreas Sommer <hsommer@eso.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here usb-stick image with the new (Alan) version of the patches.

https://susestudio.com/download/1cbfcf5c4ca89206fc170f00b962be0a/openSUSE_13.1_parport_pc.i686-0.1.0.oem.tar.gz

login root:linux or tux:linux

Heiko, could you please also check that you see EPP?

2014-07-11 1:48 GMT+04:00 Leopold Palomo-Avellaneda <leo@alaxarxa.net>:
> Hi,
>
> this thread has been very interesting. I feel that I'm one of the
> "instigators" to solve this f... bug in the kernel. But, it seems that it's
> quiet difficult, more because the kernel developers than the bug itself.
>
> But well, to be honest, the kernel developers do a great and complex job, so
> probably they have good reasons to react in that way. Think that it's the
> second time that a patch to solve this bug is rejected.
>
> Thanks Matwey for the patch and the afford to solve this bug. I have several
> boxes in the lab where I work (Dell 745) that suffer that false positives.
>
> Also, there's some pci card that also suffer that. I think that we have one.
> But, I'm not sure.
>
> So, I can check whatever could be necessary.
>
> Best regards,
>
> Leopold
>
>
>
>
> --
> --
> Linux User 152692     PGP: 05F4A7A949A2D9AA
> Catalonia
> -------------------------------------
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
