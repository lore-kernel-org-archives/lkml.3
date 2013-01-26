Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3AZC54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:57:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39711 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AZC5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:57:52 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-82-5103462e448b
Message-id: <5103462E.3060001@samsung.com>
Date: Sat, 26 Jan 2013 11:57:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] extcon: arizona: Use regulated mode for microphone supply
 when detecting
References: <1359105372-27252-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1359105372-27252-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zXV09N+ZAgwkTDCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGv9sXmApaWCouLVvP3MA4n7mLkYNDQsBE4u/ktC5GTiBTTOLC
	vfVsXYxcHEICyxglnv37wwyRMJGY+XgqVGI6o8SWVwuZIJxOJomfc1azgVTxCmhJrL56Ccxm
	EVCVeHLqOCOIzQYU3//iBlhcVCBM4uqE4ywQ9YISPybfYwG5QgRow+/7lSBhZoECiZuP/oGV
	CwvES2xee5IdxBYSCJVonHgCbCQn0Jhdv3ewQdRbS6yctI0RwpaX2LzmLTPIbRIC/9kk7jUs
	ZIe4R0Di2+RDLBAfy0psOgD1mKTEwRU3WCYwis1CctEsJGNnIRm7gJF5FaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZIREjvYFzVYHGIUYCDUYmHV4CVOVCINbGsuDL3EKMEB7OSCK+MCVOg
	EG9KYmVValF+fFFpTmrxIcZkoAMnMkuJJucDozWvJN7Q2MDY0NDS0MzU0tSANGElcV7GU08C
	hATSE0tSs1NTC1KLYLYwcXBKNTAqX8nca97hnhM5i2OGWePX030rwr1YJoTtyruhKLZqY+SE
	M1dFL7b/6fpssiLASGFWW33dbPtpS4/o5T03jBVg7vKpSMjawfcl22f++p1L3LgiUx7fe7VF
	ztHx+RTTvX+COa7ffMdjekT83J8LpW1HSrpEV3huO6L1TCBDQlazXkvhUevRjvlKLMUZiYZa
	zEXFiQBEUo1tzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV09N+ZAg5fLNC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxr/bF5gKWlgqLi1bz9zA
	OJ+5i5GTQ0LARGLm46lsELaYxIV764FsLg4hgemMElteLWSCcDqZJH7OWQ1WxSugJbH66iUw
	m0VAVeLJqeOMIDYbUHz/ixtgcVGBMImrE46zQNQLSvyYfA/I5uAQAdr2+34lSJhZoEDi5qN/
	YOXCAvESm9eeZAexhQRCJRonngAbyQk0ZtfvHWwQ9dYSKydtY4Sw5SU2r3nLPIFRYBaSDbOQ
	lM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEPZPewbiqweIQowAHoxIPrwAr
	c6AQa2JZcWXuIUYJDmYlEV4ZE6ZAId6UxMqq1KL8+KLSnNTiQ4zJwACYyCwlmpwPTAZ5JfGG
	xiZmRpZGZsYm5sbGpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoGxWH7u3aPRf9qXlyb9
	OtF37utOXtVXa+JZCuaocxXcW6D4VLNpJv9jjq60G3KTKpsUfga9LzYJFBLK3blGQG/f+fhf
	fZunqixReTH/95LvKbOWMjq2qe00jlwWy/34i3Ci7O2Dny/f+nvlm03hiaac5/cMJz2f/yJr
	QaqipLRV7rTWfvuP6xSVlViKMxINtZiLihMBck9CDPwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 06:16 PM, Mark Brown wrote:
> When starting microphone detection some headsets should be exposed to
> the fully regulated microphone bias in order to ensure that they behave
> in an optimal fashion.
>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> ---
>   drivers/extcon/Kconfig          |    2 +-
>   drivers/extcon/extcon-arizona.c |   62 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 63 insertions(+), 1 deletion(-)
Applied it.

Thanks,
Chanwoo Choi
