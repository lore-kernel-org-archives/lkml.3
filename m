Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaIDV6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:58:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44066 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaIDV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:58:15 -0400
X-AuditID: cbfee68f-f797f6d000001173-81-5408e075293b
Message-id: <5408E074.7090008@samsung.com>
Date: Fri, 05 Sep 2014 06:58:12 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
References: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>
 <5407F364.9030303@samsung.com>
 <CAPDyKFp0LwK=DABHaP-Ke=QZFP8bY5MO9RnYmUBqeEdDKp63BA@mail.gmail.com>
 <5408D81C.7070602@codeaurora.org>
In-reply-to: <5408D81C.7070602@codeaurora.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkULf0AUeIwZ15YhZ7206wW0y4vJ3R
	ouHTHVaLTY+vsVpM3H+W3eLyrjlsFkf+9zNa/DjTzWJxfG24xazjH9kcuDwu9/Uyedy5tofN
	Y/OSeo9N+6cxe9x4tZDJ4/MmuQC2KC6blNSczLLUIn27BK6MP2+aGAtOslasWJPQwLiZpYuR
	k0NCwESie+tmNghbTOLCvfVANheHkMBSRol35yYywxQ9vvaMGSIxnVFizf9vUM5rRok9q0+C
	tfMKaEn8vrEYzGYRUJXYv+U2WDebgI7E9m/HmUBsUYEwiUNt85gg6gUlfky+B3aGiICvxMcL
	u8BWMwvMYZb40XmDHSQhLOAj8bW1lR1i23lGiWkbH7GCJDgF9CQ2Np4Dm8QsoC4xad4iZghb
	XmLzmrdg50kIvGSX+DlvDjPESQIS3yYfAlrHAZSQldh0AOo3SYmDK26wTGAUm4XkqFlIxs5C
	MnYBI/MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMD4PP3vWf8OxrsHrA8xCnAwKvHwFrxg
	DxFiTSwrrsw9xGgKdMVEZinR5HxgEsgriTc0NjOyMDUxNTYytzRTEuddKPUzWEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAPjxDti+/jkt22dcOVbldzrPo1EN2FfTnmrnNOnL6zPEMpdadjw
	/fMVccOsedU6+baJnLpnL5m8tdk2746CwftMocPeUZZfb520Viv/FF9WOOfcNI7Ab+1sgrwv
	dfm0HqfOKtRX2zf7HP9Eqwk53FFhrOfM7n++d/7lxvUF+273rdC9/CVtytGTSizFGYmGWsxF
	xYkA/F9kG8oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG7pA44Qg8uveC32tp1gt5hweTuj
	RcOnO6wWmx5fY7WYuP8su8XlXXPYLI7872e0+HGmm8Xi+Npwi1nHP7I5cHlc7utl8rhzbQ+b
	x+Yl9R6b9k9j9rjxaiGTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM/68aWIsOMlasWJNQgPjZpYuRk4OCQETicfXnjFD2GISF+6tZ+ti5OIQEpjOKLHm/zdm
	COc1o8Se1SfZQKp4BbQkft9YDGazCKhK7N9yG6ybTUBHYvu340wgtqhAmMShtnlMEPWCEj8m
	3wPbJiLgK/Hxwi6wDcwCc5glfnTeYAdJCAv4SHxtbWWH2HaeUWLaxkesIAlOAT2JjY3nwCYx
	C6hLTJq3iBnClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMHR/0xqB+PKBotDjAIcjEo8vAUv2EOEWBPLiitzDzFKcDArifB+uMsRIsSbklhZlVqU
	H19UmpNafIjRFBgGE5mlRJPzgYkpryTe0NjEzMjSyNzQwsjYXEmc90CrdaCQQHpiSWp2ampB
	ahFMHxMHp1QD44FVDkkGX4+qiDGef9ue9HKHZ0fiuyo+84Ll93c+2bixQY13xn7+70+Lv8/3
	VZZhF/l3Ue2Kh4LzuWnrtS62+u+5ImR4cqJ63+9pqZcY2PreFEeGyBfdPqrDx98hZF3vufTQ
	wlV+DscNkx9EpWhIsgac+H/8xILIHGk5pWnVZyZ97zaw5/66QomlOCPRUIu5qDgRAE59CzsU	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 06:22 AM, Stephen Boyd wrote:
> On 09/04/14 03:53, Ulf Hansson wrote:
>> On 4 September 2014 07:06, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>>
>>> In dw-mmc.c, tuning_block values are same.
>>> So I think we can move these value into generic header. how about?
>> Actually, I believe these values comes from the eMMC specification?
>> Shouldn't they be moved to the mmc core instead?
> 
> That sounds like good consolidation, but can we do that in a follow-up
> patch? This fixes the driver for me and I was hoping to make something
> minimal to go back to stable trees.

Sure, if my opinion is ok, i will do it after apply your patches.

Best Regards,
Jaehoon Chung

> 

