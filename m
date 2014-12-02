Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaLBKyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:54:44 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaLBKym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:54:42 -0500
Message-ID: <547D9A6F.9010801@nod.at>
Date: Tue, 02 Dec 2014 11:54:39 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: dht11: IRQ fixes
References: <1417465651-16036-1-git-send-email-richard@nod.at> <1417465651-16036-2-git-send-email-richard@nod.at> <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Am 02.12.2014 um 11:19 schrieb Harald Geyer:
> Hi Richard,
> 
> thanks for the patch.
> 
> I think (haven't tried yet) that your patch changes the number of
> edges recorded per transmission. So probably the decoding function
> needs to be adapted too...

Can you explain your thought?
I'll happily dig into that.

> I won't be able to ACK this before testing on real HW. Of course
> confirmation that your changes work reliably on both DHT11 and DHT22
> will do as well. The debuging code present in the initial submission
> of the driver might be helpful to anybody trying to verify the
> timing.

I have only DHT22 sensors. Of course I've tested the driver with these.

> I'm doing kernel work in my free time and am quite busy with my day job
> right now, so it will take a few days before I can test your code myself.
> Sorry about that.

No need to worry!

Thanks,
//richard
