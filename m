Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaLCUUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:20:39 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbaLCUUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:20:37 -0500
Message-ID: <547F7092.8080001@nod.at>
Date: Wed, 03 Dec 2014 21:20:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Am 03.12.2014 um 13:18 schrieb Harald Geyer:
> Hi Richard,
> 
> thanks for all the work you put into this!
> 
> Richard Weinberger writes:
>> Please see my current patches for your driver.
>> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
>> With the IRQ changes I see 84 edges.
> 
> This still surprises me. With the IRQ changes I would expect the
> preamble to be 2 edges only. I must be missing something. Can you
> explain this to me?

Did some more tests.
With my IRQ changes applied I get as stated 84 edges,
without I get 85. So we're only losing one edge.

Of course if we're too slow with registering the IRQ we'll lose
more edges and the results renders unusable.

Thanks,
//richard
