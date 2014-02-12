Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaBLI6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:58:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61035 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:58:04 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-53-52fb37993741
Message-id: <1392195480.22265.2.camel@AMDC1943>
Subject: Re: [PATCH 01/14] mfd: sec: Add maximum RTC register for regmap config
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 12 Feb 2014 09:58:00 +0100
In-reply-to: <20140212084859.GO15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-2-git-send-email-k.kozlowski@samsung.com>
 <20140212084859.GO15081@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7ozzX8HGay/ZG2xccZ6VouzTW/Y
	Le5/PcpocXnXHDaLGef3MVmsPXKX3eJ0N6vFxRVfmBw4PO5c28PmMe9koEffllWMHp83yQWw
	RHHZpKTmZJalFunbJXBlfG57zF7QwlZx+tU3tgbGKyxdjJwcEgImEgeuf2WCsMUkLtxbz9bF
	yMUhJLCUUeLU1G9MEM5nRom2mTuZQap4BfQlXr6fzA5iCwv4Syw73ssGYrMJGEtsXr4EyObg
	EBFQkTj3xhykl1lgMZPEmf7DYDUsAqoSD+dsApvDKaAr8blhJTPEgmWMErevvwY7g1lAXWLS
	vEXMECcpSexu72SHiMtLbF7zFuoIQYkfk++xTGAUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECAnyLzsYFx+zOsQowMGoxMPL4PkrSIg1say4MvcQowQHs5IIr/4J
	oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGzE9WlwKk3ksUzHVz2PA/qPJgmdObUx7eTrs/Xn54
	++PN3nr31M9/KzLulC4TMnUX1/mbsfLpj2R2xhrbQ3wVJ2pee54S8J422dfo8lOGlE/1Z2Xu
	MohY5DH2fDsS+9Bji6Wdde0t/VN3/6owFJzSOOi26eiLRSx5099aPfPxkAjcelfQ5lyGEktx
	RqKhFnNRcSIAUDwtNVACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 08:48 +0000, Lee Jones wrote:
> > Add maximum register to the regmap used by rtc-s5m driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c          |    2 ++
> >  include/linux/mfd/samsung/rtc.h |    2 ++
> >  2 files changed, 4 insertions(+)
> 
> I guess some of these patches depend on some others?
> 
> When provided with their Acked-by:s, I'm happy to take this whole
> patch-set and create an immutable branch for the other maintainer()s
> in the set to pull from.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>

Only few of these patches can be picked independently so your idea
sounds good. All I have to do is to get the acks... :)

Best regards,
Krzysztof

