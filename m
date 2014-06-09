Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaFIX7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:59:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60594 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaFIX7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:59:04 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-44-53964a451394
Message-id: <53964A45.3010108@samsung.com>
Date: Tue, 10 Jun 2014 08:59:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: of: Add support for parsing regulator_state
 for suspend state
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
 <1402309780-8118-2-git-send-email-cw00.choi@samsung.com>
 <20140609192133.GD5099@sirena.org.uk>
In-reply-to: <20140609192133.GD5099@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkRNfVa1qwwf4GA4upD5+wWcw/co7V
	4sCfHYwWZ5vesFt8u9LBZHF51xw2i9uNK9gsWvceYXfg8Ng56y67x6ZVnWwed67tYfPo27KK
	0ePzJrkA1igum5TUnMyy1CJ9uwSujO/9V9kLfrBXTN++m6WB8SBbFyMHh4SAiUTXFsUuRk4g
	U0ziwr31QGEuDiGBpYwSk/6vYoZImEisnXKdGSKxiFFi+dUPjCAJIYHXjBJbHmSC2LwCWhLL
	lyxgBbFZBFQllrxdygRiswHF97+4wQZiiwqESaycfoUFol5Q4sfke2C2iICyxNXve1lAFjAL
	bGeU2L7jPthmYYFkic/PXrNCLFvOKHHsEDeIzSlgJPHk7E2wBcwCOhL7W6exQdjyEpvXvAW7
	VELgGrvEzv8/GCEuEpD4NvkQC8TLshKbDkB9JilxcMUNlgmMYrOQ3DQLydhZSMYuYGRexSia
	WpBcUJyUXmSkV5yYW1yal66XnJ+7iREYgaf/PevbwXjzgPUhxmSglROZpUST84ERnFcSb2hs
	ZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFXntwu0XtAK
	F3lx2y7yxpFkYZN1aYopS7MmzIxfURzmsWcfk9fFnBdFwotMebm8YsOsTu03jpjB533gd5eV
	+4EH0zcK87l+nL7zw7UTjgs3GK7fkCv8L0Ky/lSz+q+mJQ1GszdFXak27fQMmrc/7vXCrH1P
	Ptz1qUoK27GG++VntyuXeL9vUFFiKc5INNRiLipOBAAwV/NL1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAV1Xr2nBBj8/a1hMffiEzWL+kXOs
	Fgf+7GC0ONv0ht3i25UOJovLu+awWdxuXMFm0br3CLsDh8fOWXfZPTat6mTzuHNtD5tH35ZV
	jB6fN8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz43n+VveAHe8X0
	7btZGhgPsnUxcnJICJhIrJ1ynRnCFpO4cG89UJyLQ0hgEaPE8qsfGEESQgKvGSW2PMgEsXkF
	tCSWL1nACmKzCKhKLHm7lAnEZgOK739xA2yoqECYxMrpV1gg6gUlfky+B2aLCChLXP2+lwVk
	AbPAdkaJ7Tvug20WFkiW+PzsNSvEsuWMEscOcYPYnAJGEk/O3gRbwCygI7G/dRobhC0vsXnN
	W+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/yZ1A7GlQ0W
	hxgFOBiVeHgtDkwNFmJNLCuuzD3EKMHBrCTCy/oRKMSbklhZlVqUH19UmpNafIgxGRgEE5ml
	RJPzgcknryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pYDxVdtz
	O+RIFUfUohnbPfvmLLtpdfFa5gQGbaXaqh1cATM1XisYCm6b2nzLjqPrMevz7FWn9h4WX2C9
	buIqqaUbpW0L866qPCuRqbPsMdNYlXh8DuvsZ1M0DIvEPytnlAvseeKovclvUkRpxtNU97/X
	Y1NO679fcbhb9GjZmlTxX+z9Wt1X+ruUWIozEg21mIuKEwEK5BgvNAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 06/10/2014 04:21 AM, Mark Brown wrote:
> On Mon, Jun 09, 2014 at 07:29:39PM +0900, Chanwoo Choi wrote:
> 
>> +		ret = of_property_read_u32(suspend_np, "regulator-mode", &pval);
>> +		if (!ret)
>> +			suspend_state->mode = pval;
> 
> If we're going to do that we'd need to define what modes mean in the DT
> binding - currently there's no support for modes at all because it's
> complicated to come up with sensible and meaningful generic defintions.
> 

The 'regulator-mode' of this patch means following defined constant variable
as following in include/linux/regulator/consumer.h:
#define REGULATOR_MODE_FAST		0x1
#define REGULATOR_MODE_NORMAL		0x2
#define REGULATOR_MODE_IDLE		0x4
#define REGULATOR_MODE_STANDBY		0x8

If regulator consumer would use this mode('regulator-mode),
specific regulator driver should implement rdev->desc->ops->set_suspend_mode function
to control regulator state according to 'regulator-mode' in suspend state.

Best Regards,
Chanwoo CHoi



