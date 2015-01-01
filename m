Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbbAAMi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 07:38:28 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55889 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbbAAMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 07:38:26 -0500
Message-ID: <54A53FBF.5000003@kernel.org>
Date: Thu, 01 Jan 2015 12:38:23 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: harald@ccbib.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at>
In-Reply-To: <1417563176-31972-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/14 23:32, Richard Weinberger wrote:
> Please see my current patches for your driver.
> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
> With the IRQ changes I see 84 edges.
> 
> I have also a question on your driver. Why you increment
> DHT11_DATA_BIT_LOW/timeres by one in the ambiguity check?
> 
>         threshold = DHT11_DATA_BIT_HIGH / timeres;
>         if (DHT11_DATA_BIT_LOW/timeres + 1 >= threshold)
>                 pr_err("dht11: WARNING: decoding ambiguous\n");
> 
> Thanks,
> //richard
> 
> [PATCH 1/4] iio: dht11: Add locking
> [PATCH 2/4] iio: dht11: IRQ fixes
> [PATCH 3/4] iio: dht11: Logging updates
> [PATCH 4/4] iio: dht11: Fix out-of-bounds read
> 
Hi all,

I've lost track of where we are with this patch series.
Does this cause trouble on any of the parts supported?
