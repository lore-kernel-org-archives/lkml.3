Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBNHdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:33:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27379 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaBNHdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:33:44 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-d3-52fdc6d55d6f
Message-id: <1392363220.29133.4.camel@AMDC1943>
Subject: Re: [PATCH v2 09/14] regulator: s2mps11: Add support for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Fri, 14 Feb 2014 08:33:40 +0100
In-reply-to: <20140213191028.GC28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-10-git-send-email-k.kozlowski@samsung.com>
 <20140213191028.GC28112@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7pXj/0NMnjXZWmxccZ6VoupD5+w
	WZxtesNucf/rUUaLb1c6mCwu75rDZjHj/D4mi7VH7rJbnO5mtbi44guTA5fHzll32T02repk
	87hzbQ+bx7yTgR59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8fHsFqaCTWwVC9t2Mjcw9rF2
	MXJwSAiYSFxcqt/FyAlkiklcuLeerYuRi0NIYCmjxOUdTYwgCSGBz4wSE54qgdTzCuhLzNjN
	ARIWFgiTuHS6kR3EZhMwlti8fAkbiC0ioCxx9fteFpA5zAJvmCRWzd7OCpJgEVCVmNp+jAXE
	5gRqeL/wDCPEsvWMEgsWPQLrZhZQl5g0bxEzxEVKErvbO9kh4vISm9e8BYvzCghK/Jh8j2UC
	o8AsJC2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIJHzZwbj4mNUhRgEO
	RiUe3g93/wQJsSaWFVfmHmKU4GBWEuF13/83SIg3JbGyKrUoP76oNCe1+BAjEwenVAOjRHzU
	9FCOo37XLXw8t/6/KC7G0sMVXfn7wcnA6zpLRIQzPnDvWfM35d/LxQfknCRSTF7tC42ZEP9V
	RW/hE6Gq5DDlpLP52fMatX77pL6Zm/I+8vmOo3YrXasKPuywNdwx58zCp50vZ3yOjLsQGj+7
	880JFd+HMTaqcklnWWYv+lu4yszcyUhYiaU4I9FQi7moOBEATcKblGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 19:10 +0000, Mark Brown wrote:
> On Thu, Feb 13, 2014 at 10:14:02AM +0100, Krzysztof Kozlowski wrote:
> > Add support for S2MPS14 PMIC regulators to s2mps11 driver. The S2MPS14
> > has fewer BUCK-s and LDO-s than S2MPS11. It also does not support
> > controlling the BUCK ramp delay.
> 
> How different are the other Samsung PMICs?  They share the core driver
> code and this makes the driver more parameterisable so perhaps it means
> the others could be merged in here too.

With some effort the s2mps11 and s5m8767 regulator drivers can be
merged. The s5m8767 shares most of the features with s2mps11 and adds
some new stuff (i.e. GPIO control over BUCK DVS, low power mode for
opmode). Anyway it was easier to add support for S2MPS14 to S2MPS11 than
to merge everything now.

