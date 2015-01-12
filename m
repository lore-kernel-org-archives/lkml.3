Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbbALKj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:39:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57822 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbbALKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:39:54 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-2d-54b3a478ef24
Message-id: <54B3A477.8080705@samsung.com>
Date: Mon, 12 Jan 2015 19:39:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene@kernel.org>
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, inki.dae@samsung.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Add exynos3250 suspend-to-ram support
References: <1420681838-4292-1-git-send-email-cw00.choi@samsung.com>
 <54B38989.4030700@kernel.org> <54B38B24.20804@samsung.com>
 <54B393B9.6060806@kernel.org>
In-reply-to: <54B393B9.6060806@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkULdiyeYQgz8LuSw2zljPajFp3QEm
	i0n3J7BYvH5haNH/+DWzxdmmN+wWmx5fY7W4vGsOm8WM8/uYHDg9/q56weyxaVUnm8fmJfUe
	fVtWMXp83iQXwBrFZZOSmpNZllqkb5fAldG+/wxrwVOuiidN85kbGD9wdDFyckgImEisf36A
	DcIWk7hwbz2QzcUhJLCUUeLd/l2MMEWfLoHYIInpjBIHtq9mAUkICbxmlOg6zwNi8wpoSUx/
	eQiom4ODRUBVYtJlSZAwG1B4/4sbYAtEBcIkVk6/wgJRLijxY/I9FpByEQFFic0LFEDGMwu8
	YJR4/uYcM0iNsICfxMNrD5gh9i5klNj1sJEJJMEJNHTekV9gg5gFdCT2t05jg7DlJTaveQvW
	ICFwi13i8dNHYA0sAgIS3yYfAtsmISArsekAM8RjkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZV
	jKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIFxePrfswk7GO8dsD7EKMDBqMTDayG1OUSINbGs
	uDL3EKMp0BUTmaVEk/OB0Z5XEm9obGZkYWpiamxkbmmmJM77WupnsJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGtSeFFOcsfSufE295r734gXTFo3LPHXKBL5Lesj35PF/xhMD5y8tbV4qo
	bVok8Xz5AhEOV1GjW21BtbJBjzTmG15Uq9Uv2/Zp9QKuy4sKQ8Pz+x+9+VTabvMztfTQlr8N
	9is+e756Fm/69M2TD5w3u5Km1tZp3ZoY+cNZKsvpBPevdScNi6yllViKMxINtZiLihMBBRc7
	Tr4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd2KJZtDDM4/ZbLYOGM9q8WkdQeY
	LCbdn8Bi8fqFoUX/49fMFmeb3rBbbHp8jdXi8q45bBYzzu9jcuD0+LvqBbPHplWdbB6bl9R7
	9G1ZxejxeZNcAGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
	i0+ArltmDtA9SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM9v1nWAue
	clU8aZrP3MD4gaOLkZNDQsBE4tOlXYwQtpjEhXvr2boYuTiEBKYzShzYvpoFJCEk8JpRous8
	D4jNK6AlMf3lIaAiDg4WAVWJSZclQcJsQOH9L26wgdiiAmESK6dfYYEoF5T4MfkeC0i5iICi
	xOYFCiDjmQVeMEo8f3OOGaRGWMBP4uG1B8wQexcySux62MgEkuAEGjrvyC+wQcwCOhL7W6ex
	QdjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOMqf
	Se9gXNVgcYhRgINRiYfXQmpziBBrYllxZe4hRgkOZiURXtcyoBBvSmJlVWpRfnxRaU5q8SFG
	U2AITGSWEk3OByagvJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkG
	Rq5AjoV7PP2Y7aafvaG0VTE4/dSJ2BLTCY7yhm6i/o8Vf2y2WCjB8d9G8vr1iNgl0u6smyNz
	w/e93rv19s3JviYrfU89n8at9S722fbCXepxcyV5GwL2XJzrLMjte/3iTr9+g71bnLfH8uTY
	7V0nLjPzc1vmnO8bWWOLxX8KeHzJtIi6OzfUTYmlOCPRUIu5qDgRAC61TpAIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 01/12/2015 06:28 PM, Kukjin Kim wrote:
> On 01/12/15 17:51, Chanwoo Choi wrote:
>> Dear Kukjin,
>>
>> On 01/12/2015 05:44 PM, Kukjin Kim wrote:
>>> On 01/08/15 10:50, Chanwoo Choi wrote:
>>>> This patch adds the support for suspend-to-ram feature of Exynos3250 SoC.
>>>> Exynos3250 don't contain the L2 cache.
>>>>
>>>> Cc: Kukjin Kim <kgene@kernel.org>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> Depend on:
>>>> - v3.19-rc3
>>>>
>>> Chanwoo,
>>>
>>> Can you please let me know why this is depending on v3.19-rc3?
>>> If I apply this on top of my tree not including some stuff between
>>> v3.19-rc1 and v3.19-rc3, is there a problem?
>>
>> No problem.
>> I'm sorry. It is my mistake about using meaning of dependency.
>> This patch can be applied on v3.19-rc1. I just tested it on v3.19-rc3.
>>
> OK, applied.

Thanks for your apply.

I check this patch on your git repository on following:
https://git.kernel.org/cgit/linux/kernel/git/kgene/linux-samsung.git/commit/?h=v3.20-next/update-samsung&id=e2fb3668567d0b70563cca0d1e350afd5053e4a3

Although this patch contains a little decription of patch,
applied patch don't include any description of patch.

If you possible, please add the description of patch.

Best Regards,
Chanwoo Choi
