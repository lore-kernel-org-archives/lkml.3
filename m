Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaFJKZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:25:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35330 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFJKZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:25:48 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-39-5396dd2a8df3
Message-id: <5396DD2A.7060701@samsung.com>
Date: Tue, 10 Jun 2014 19:25:46 +0900
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
 <20140609192133.GD5099@sirena.org.uk> <53964A45.3010108@samsung.com>
 <20140610100232.GD5099@sirena.org.uk>
In-reply-to: <20140610100232.GD5099@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkQFfr7rRgg8snpS2mPnzCZjH/yDlW
	iwN/djBanG16w27x7UoHk8XlXXPYLG43rmCzaN17hN2Bw2PnrLvsHptWdbJ53Lm2h82jb8sq
	Ro/Pm+QCWKO4bFJSczLLUov07RK4Muaf62QraOOsWDDzEnMD4372LkZODgkBE4lTF7rZIGwx
	iQv31gPZXBxCAksZJT7P64Iret6wEiqxiFHifON/JgjnNaPEq7cTGUGqeAW0JOZ838cMYrMI
	qEr83rsDzGYDiu9/cQNshahAmMTK6VdYIOoFJX5MvgdmiwgoS1z9vpcFZCizwHZGie077oM1
	CwskS3x+9poVYts7Rom5xz6BTeIUMJJ4sW8lWDezgI7E/tZpbBC2vMTmNW+ZQRokBK6xSxxb
	PBXqJAGJb5MPATVwACVkJTYdYIb4TVLi4IobLBMYxWYhOWoWkrGzkIxdwMi8ilE0tSC5oDgp
	vchQrzgxt7g0L10vOT93EyMwDk//e9a7g/H2AetDjMlAKycyS4km5wPjOK8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGEv2rbhSot5k+Grvsvxf
	PHk+Wabir2zsyldLqiQv3bMoxuOdwvH+88tXFykIRZkGGvvV/O6ZqPyadfbsDseo2m/uVddi
	7W4vr3y3NltX+JjKvfIP7Eu8Hz5fffPurGXPQlQb/raGXFwfx3j/bdlc5+xteyIvxlnxVvOf
	OeCl0OKttU/F3FxLWomlOCPRUIu5qDgRAOiH88LZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAV2tu9OCDX7PFbaY+vAJm8X8I+dY
	LQ782cFocbbpDbvFtysdTBaXd81hs7jduILNonXvEXYHDo+ds+6ye2xa1cnmcefaHjaPvi2r
	GD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx/1wnW0EbZ8WC
	mZeYGxj3s3cxcnJICJhIPG9YyQZhi0lcuLceyObiEBJYxChxvvE/E4TzmlHi1duJjCBVvAJa
	EnO+72MGsVkEVCV+790BZrMBxfe/uAE2SVQgTGLl9CssEPWCEj8m3wOzRQSUJa5+38sCMpRZ
	YDujxPYd98GahQWSJT4/e80Kse0do8TcY5/AJnEKGEm82LcSrJtZQEdif+s0NghbXmLzmrfM
	ExgFZiFZMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf5M6kdjCsbLA4x
	CnAwKvHwWhyYGizEmlhWXJl7iFGCg1lJhPfLyWnBQrwpiZVVqUX58UWlOanFhxiTgWEwkVlK
	NDkfmIDySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGx6E7Z
	yqdmz/eee+7O2qb0oW9xh5nDtUP33y+7G6QYKCb4ObjizFqBlG1fPktca39r3modZ+CQv/x4
	5uMySS/BPdOr9pxM3bzczqX58CVVsTmndS9vfLjkeP7Epwuk7gtdYn34PeXsH68P/+w6k5Yn
	HMnNdExV8jnKeSzQSHTHCScvM5asIz2NSizFGYmGWsxFxYkA2NCrbzYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 07:02 PM, Mark Brown wrote:
> On Tue, Jun 10, 2014 at 08:59:01AM +0900, Chanwoo Choi wrote:
>> On 06/10/2014 04:21 AM, Mark Brown wrote:
> 
>>> If we're going to do that we'd need to define what modes mean in the DT
>>> binding - currently there's no support for modes at all because it's
>>> complicated to come up with sensible and meaningful generic defintions.
> 
>> The 'regulator-mode' of this patch means following defined constant variable
>> as following in include/linux/regulator/consumer.h:
>> #define REGULATOR_MODE_FAST		0x1
>> #define REGULATOR_MODE_NORMAL		0x2
>> #define REGULATOR_MODE_IDLE		0x4
>> #define REGULATOR_MODE_STANDBY		0x8
> 
>> If regulator consumer would use this mode('regulator-mode),
>> specific regulator driver should implement rdev->desc->ops->set_suspend_mode function
>> to control regulator state according to 'regulator-mode' in suspend state.
> 
> Sure, but what do those mean?
> 

We could check basic explanation of regulator mode in include/linux/regulator/consumer.h.
Should I add detailed descritpion of REGULATOR_MODE_* constant in drivers/regulator/of_regulator.c?



