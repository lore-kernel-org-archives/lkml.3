Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaFPXl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:41:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19210 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaFPXl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:41:56 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-d2-539f80c22b7b
Message-id: <539F80C2.90609@samsung.com>
Date: Tue, 17 Jun 2014 08:41:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, k.kozlowski@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCHv5 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
References: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
 <1402893757-18957-3-git-send-email-cw00.choi@samsung.com>
 <20140616131911.GV14323@lee--X1>
In-reply-to: <20140616131911.GV14323@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkQPdQw/xggz2nDSw6zz5htnj9wtDi
	bNMbdov7X48yWlzeNYfN4nbjCjaL092sFhdXfGFy4PC4c20Pm8e8k4EefVtWMXp83iQXwBLF
	ZZOSmpNZllqkb5fAlTHpywSmgj+cFa++PGdqYOzi6GLk5JAQMJGYf76fHcIWk7hwbz1bFyMX
	h5DAUkaJzXPXssIUzfi+G8wWEpjOKHFiQSZE0WtGiS2L57OBJHgFNCRurNjNAmKzCKhKXFvc
	CRZnE9CS2P/iBpgtKhAmsXL6FRaIekGJH5PvAdkcHCICKhLn3piDzGQWOMYosXbDLkaQGmGB
	UIm5j18xQyxbwijRcOkFWIJTQFfi7tV+JhCbWUBdYtK8RcwQtrzE5jVvwRokBM6xS8xa+w7q
	IgGJb5MPgW2TEJCV2HSAGeIzSYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IiO9
	4sTc4tK8dL3k/NxNjMCYO/3vWd8OxpsHrA8xJgOtnMgsJZqcD4zZvJJ4Q2MzIwtTE1NjI3NL
	M9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGCaUV15uv63f4O1579l2Z//u
	qVp2PVfw99FKxVpdodqekMUP6/lLd9/d8uHkrM0f9UNZb98XfN2Y9q7BROm2v6/mvyCTaZy3
	DsdumlNsfNN89c68xiazfV2GEqxVOdf0w/YdjX2ycdvMb5f6JgVfmPQs62CaVtEejubNx1g+
	NGmtTfHijxflVWIpzkg01GIuKk4EANi99TDPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd1DDfODDR5N0bDoPPuE2eL1C0OL
	s01v2C3ufz3KaHF51xw2i9uNK9gsTnezWlxc8YXJgcPjzrU9bB7zTgZ69G1ZxejxeZNcAEtU
	A6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMSV8mMBX84ax49eU5UwNjF0cX
	IyeHhICJxIzvu1khbDGJC/fWs4HYQgLTGSVOLMjsYuQCsl8zSmxZPB8swSugIXFjxW4WEJtF
	QFXi2uJOsDibgJbE/hc3wGxRgTCJldOvsEDUC0r8mHwPyObgEBFQkTj3xhxkJrPAMUaJtRt2
	MYLUCAuESsx9/IoZYtkSRomGSy/AEpwCuhJ3r/YzgdjMAuoSk+YtYoaw5SU2r3nLPIFRYBaS
	HbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEP5PewbiqweIQowAHoxIP
	7wPZ+cFCrIllxZW5hxglOJiVRHi5zIFCvCmJlVWpRfnxRaU5qcWHGJOBQTCRWUo0OR+YbPJK
	4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXGdJcvS1Q8Fnx4u
	jS6O1vZ/sX1GwaHKBTM74sTmZkipFb7uude7YYeOnOq/vbuFt6/mmS04L+xvQtUZ4eeeRWpb
	KnfyG3vdZF63JS2n/cUSL3czQbbdRcvdBaLvXUnaetJzUtmX7zbVy6aY9zsIWMnW8FyL/hSf
	8eSJtZp9q2Px8dJZh2e++qbEUpyRaKjFXFScCACE+f0+LAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 06/16/2014 10:19 PM, Lee Jones wrote:
> On Mon, 16 Jun 2014, Chanwoo Choi wrote:
> 
>> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
>> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
>> regulator device includes LDO[1-28] and BUCK[1-7].
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> [Add missing linear_min_sel of S2MPU02 LDO regulators by Jonghwa Lee]
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> Acked-by: Mark Brown <broonie@linaro.org>
>> ---
>>  drivers/mfd/sec-core.c              |  25 +++
>>  drivers/regulator/s2mps11.c         | 321 +++++++++++++++++++++++++++++++++---
>>  include/linux/mfd/samsung/s2mpu02.h | 201 ++++++++++++++++++++++
>>  3 files changed, 526 insertions(+), 21 deletions(-)
>>  create mode 100644 include/linux/mfd/samsung/s2mpu02.h
> 
> MFD changes look good to me.
> 
>   Acked-by: Lee Jones <lee.jones@linaro.org>

Thanks.

> 
> I assume we have to wait for the other patches to be ready before
> applying this one?

We don't need to wait for the other patches because related patches
was already merged on Linux 3.16-rc1.

Best Regards,
Chanwoo Choi
