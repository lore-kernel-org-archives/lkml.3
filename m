Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaLEUNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:13:54 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13890 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaLEUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:13:52 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f3-548211fd4ab2
Message-id: <548211FC.2050901@samsung.com>
Date: Fri, 05 Dec 2014 21:13:48 +0100
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 0/5] iio: common: ssp_sensors: Add sensorhub driver
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
In-reply-to: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xa7p/BZtCDHr2KlhsnLGe1eJB0yom
	i13/3zBbnG16w24x78g7FovLu+awWexZt4XJgd1j56y77B4fPsZ5bFrVyebRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGX8uvmEuaOOoWHdkNUsD4yS2LkZODgkBE4llbV+ZIWwxiQv31gPF
	uTiEBJYySky/38MM4XxilGg73QhWxSugJdF8uBOoioODRUBV4mNXAkiYTUBdonnHYrASUYEI
	iStr5jBClAtK/Jh8jwVkjohAC6PEi5+7WEEcZoF2Ron7m86zg1QJC3hJzFpwngnEFhJwknh2
	7BfYJE4BZ4lr32aAxZkFbCUWvF/HAmHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILi
	pPRcQ73ixNzi0rx0veT83E2MkDD/soNx8TGrQ4wCHIxKPLwXrBtDhFgTy4orcw8xSnAwK4nw
	Js8GCvGmJFZWpRblxxeV5qQWH2Jk4uCUamB0bXbntg61qz2ZaXruZ/CRxXV8ntk3C3cznjyV
	mv1rhfNyDgtfnWt8CfrB0b9bP338JzNja+6SKxGTtvc1bPr/ulnGZcXu+fMeXPgTOdfcLIn3
	pMXv8mNWE3XUXv6UDl69dkOWV3vKnYKV11uurDJlv8ja8k2weedh+RfmcXdVEmwdTwdmq09R
	YinOSDTUYi4qTgQAlnELWlECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 08:54 PM, Karol Wrona wrote:
> This patchset adds support for sensorhub. It is an external mcu which
> manages and collects data from several sensors i.e. on Galaxy Gear 2 watch.
>
> It contains:
> - spi driver for sensorhub device
> - DT binding for the device
> - IIO common utils for ssp sensors (iio kfifo setup helpers, pre/post callbacks)
> - IIO accelerometer driver
> - IIO gyroscope driver
>
> For now the driver supports "traditional" sensors but new ones types are
> intended to be used.
>
>>From v1:
>    - Adopted to new stm32fwu v5
>    - Fixed sensors' data process callbacks
>    - Fixed comments style
>
>>From v2:
>    - Fixes after Hartmut Knaack review
>    - Sensorhub driver was moved from misc to iio after the discussion with Arnd
>      and Jonathan
>    - Firmware upgrade is not supported in this patchset. I hope it will be
>      applied when it will find its own place in the tree.

I noticed that I left "Change-Id". I will fix it and resend after review.

