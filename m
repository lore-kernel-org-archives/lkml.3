Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaLZAJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:09:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12884 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLZAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:09:15 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-2e-549ca7295328
Message-id: <549CA728.4050606@samsung.com>
Date: Fri, 26 Dec 2014 09:09:12 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lgirdwood@gmail.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH] regulator: rt5033-regulator: Use regulator_nodes/of_match
 in the descriptor
References: <1418901216-19030-1-git-send-email-beomho.seo@samsung.com>
 <20141222151025.GY17800@sirena.org.uk> <54992212.8050707@samsung.com>
 <20141224125600.GB17800@sirena.org.uk>
In-reply-to: <20141224125600.GB17800@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkWFdz+ZwQg20rJS2mPnzCZnH9y3NW
	i0n3J7BYfLvSwWRxedccNovPvUcYLWZMfsnmwO6xc9Zddo9NqzrZPPq2rGL0+LxJLoAlissm
	JTUnsyy1SN8ugSvjbO9MpoInbBXLpn9mbWDczdrFyMkhIWAicb19PpQtJnHh3no2EFtIYCmj
	xOolTDA1DQfOskLEpzNK9O7N7mLkArJfM0os39/GDJLgFdCSuNLRzAJiswioSsz6dAssziag
	KfF+yhWwuKhAhMSHVV/ZIOoFJX5MvgcWFxFQlrj6fS8LyFBmgRmMEq27loJtFhZIkjh08zAL
	xLbtjBLbbqwGO4NTwFji+PO1QEUcQB16EvcvaoGEmQXkJTavecsMUi8hcIpdYs2WdawQFwlI
	fJt8iAWkXkJAVmLTAWaIzyQlDq64wTKBUWwWkptmIUydhWTqAkbmVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxiBsXb637MJOxjvHbA+xCjAwajEw/sgZnaIEGtiWXFl7iFGU6AjJjJLiSbn
	AyM6ryTe0NjMyMLUxNTYyNzSTEmc97XUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjCxi
	Enwnc6ed0padrvOJIbPo4tqNZUeexmw0X7t6zcSHd0yu/nQsiinfutVXS3Bnp82/Mye+bZt9
	dPnM13aBMosSP328eN9GumyHUbfR5FtiNc+lChd5nQzMzNhb/C3ofm2wq71RQVRDyL4PB84e
	aZnHNCHenkPQXWnG2Yc986vmdwVsN0o+uVmJpTgj0VCLuag4EQDiPSd6sAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQV3N5XNCDJZO5LKY+vAJm8X1L89Z
	LSbdn8Bi8e1KB5PF5V1z2Cw+9x5htJgx+SWbA7vHzll32T02repk8+jbsorR4/MmuQCWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGWd7ZzIVPGGrWDb9M2sD427WLkZO
	DgkBE4mGA2ehbDGJC/fWs4HYQgLTGSV692Z3MXIB2a8ZJZbvb2MGSfAKaElc6WhmAbFZBFQl
	Zn26BRZnE9CUeD/lClhcVCBC4sOqr2wQ9YISPybfA4uLCChLXP2+lwVkKLPADEaJ1l1LmUAS
	wgJJEoduHmaB2LadUWLbjdVgJ3EKGEscf74WqIgDqENP4v5FLZAws4C8xOY1b5knMArMQrJj
	FkLVLCRVCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/IzqR2MKxssDjEKcDAq8fA+
	iJkdIsSaWFZcmXuIUYKDWUmEl8lgTogQb0piZVVqUX58UWlOavEhRlNgCExklhJNzgemmbyS
	eENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBsYW+bwjxSunKunOmcN8
	9Nzz7ytLjF5uT5t3011pslVGRegbhZz4VavMK6t+9ygsszDOPKrzvLaeTbm96M63E6/6Tz10
	FN4UNXXBZk/vyofVMyT2ms6b+7OsfLnM1PYn/W7Rh64avH+gM8HmqSPzBMu+F+fK686HKYTc
	XtvgvlT3XfPRtny2WBMlluKMREMt5qLiRACJb21X+wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 09:56 PM, Mark Brown wrote:
> On Tue, Dec 23, 2014 at 05:04:34PM +0900, Beomho Seo wrote:
>> On 12/23/2014 12:10 AM, Mark Brown wrote:
> 
>>> This isn't replacing existing code with use of the framework, it's
>>> adding new bindings where there were none before so it needs to add a
>>> binding document too.
> 
>> Actually, RT5033 device tree binding document sent at mainling list already.
>> link is below,
>> http://marc.info/?l=linux-pm&m=141890859525642&w=2
>> It include regulator device node but above patch not applied yet.
>> If you want, I will revise dt binding document patch and send to mailing list.
> 
> OK, I've applied this but please in future send the code and binding
> documentation together to avoid such confusion.
> 

Thank you for response.
I will send code and binding documentation together at early date.
