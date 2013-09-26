Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3IZGgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:36:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39849 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3IZGgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:36:04 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-d2-5243d5d24cb6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <000d01ceba5d$2bb4b0f0$831e12d0$%han@samsung.com>
In-reply-to: <000d01ceba5d$2bb4b0f0$831e12d0$%han@samsung.com>
Subject: Re: [PATCH V2 07/18] regulator: lp3971: use devm_regulator_register()
Date: Thu, 26 Sep 2013 15:36:02 +0900
Message-id: <002d01ceba82$ab88ff00$029afd00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAJkkAAAlHlPA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zI91LV52DDP4fNLc4Mucrs8XUh0/Y
	LP4/es1qcXnhJVaLb1c6mCwu75rDZnHyTy+jA7vHzll32T3afpZ5bFrVyeZx59oeNo++LasY
	PbZfm8fs8XmTXAB7FJdNSmpOZllqkb5dAlfGjh9zWQousVXM+neBrYFxFWsXIyeHhICJRPPh
	xewQtpjEhXvr2boYuTiEBJYxStw/2csEU7Ro+zN2iMR0RomWhiNsIAkhgV+MEr/WmYLYbAJq
	El++HAabJCLgL7H77hNWkAZmga2MElOX/GKCaCiU+PZrBwuIzSlgJ7H8/l6gOAeHsICfxLor
	oiBhFgFVieUH+sHm8ArYSiw8uYEFwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3zCBjJATUJR79
	1YU4wUpi/4yVjBAlIhL7XrxjBDlHQuAvu8TVradZIXYJSHybfIgFoldWYtMBZoh/JSUOrrjB
	MoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ594djLcP
	WB9iTAZaP5FZSjQ5H5gO8kriDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAOOe24625DekHGm5Nbnp6MkXOSvuQxe5cgbLKGrX2+bpfY1+/buGJEWjP
	rZ8ovCO8wn1+S+b7e/2sicd/S7t83eBikfi4prnTsO4hy8am5HmsWlM21HX98Wzewno+2zTA
	4ENIaswFx43HjnCFiPkILXztsuBsdcis0NvBXwXkLvgL1zq9V3yoxFKckWioxVxUnAgAkbhD
	Pv0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd1LV52DDD5uMrY4Mucrs8XUh0/Y
	LP4/es1qcXnhJVaLb1c6mCwu75rDZnHyTy+jA7vHzll32T3afpZ5bFrVyeZx59oeNo++LasY
	PbZfm8fs8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjB0/5rIU
	XGKrmPXvAlsD4yrWLkZODgkBE4lF25+xQ9hiEhfurWfrYuTiEBKYzijR0nCEDSQhJPCLUeLX
	OlMQm01ATeLLl8NgDSIC/hK77z5hBWlgFtjKKDF1yS8miIZCiW+/drCA2JwCdhLL7+8FinNw
	CAv4Say7IgoSZhFQlVh+oB9sDq+ArcTCkxtYIGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywwy
	RkJAXeLRX12IE6wk9s9YyQhRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4WTyT2sG4ssHiEKMAB6MSD+8FZucgIdbEsuLK3EOMEhzMSiK8
	34yAQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTGR5JfGGxiZmRpZGZhZGJubmpAkrifMe
	aLUOFBJITyxJzU5NLUgtgtnCxMEp1cDo8088auI2FrvLJ8y8Ly0I1zq2eN6Enxu8m/7PaH9p
	dc/qmeaLi4kCvyftX/4l/8lE3uqbfa4FZRNZbpYsf+Cc+rX55YLHuxZo6860jbr8wSBX8FX4
	5Vfqe7ysOlM3vE+u+5DZPn/mCr/mQ08n9/Jc9J3Ypf3YcYWIVEH6taXX3fYdmR5Wv+jKQiWW
	4oxEQy3mouJEAPkexUBaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 11:08 AM, Jingoo Han wrote:
> 
> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/lp3971.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>

[....]
 
> @@ -463,10 +462,6 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
>  static int lp3971_i2c_remove(struct i2c_client *i2c)
>  {
>  	struct lp3971 *lp3971 = i2c_get_clientdata(i2c);
> -	int i;
> -
> -	for (i = 0; i < lp3971->num_regulators; i++)
> -		regulator_unregister(lp3971->rdev[i]);
> 
>  	kfree(lp3971->rdev);

CC'ed Sachin Kamat,

Calling regulator_unregister(lp3971->rdev) after kfree(lp3971->rdev)
would make the problem.
I will remove this patch from next v3 patch series.

Best regards,
Jingoo Han


