Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3FXByc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:54:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33830 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3FXBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:54:30 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fef6d000002d62-b9-51c7a6d5bf50
Content-transfer-encoding: 8BIT
Message-id: <51C7A6D2.8060709@samsung.com>
Date: Mon, 24 Jun 2013 10:54:26 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] regulator: max77693: Add max77693 regualtor driver.
References: <1371711806-18826-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130621151930.GB27646@sirena.org.uk>
In-reply-to: <20130621151930.GB27646@sirena.org.uk>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkSPfqsuOBBqe7eSymPnzCZnF51xw2
	i8+9RxgtmrZPYLe43biCzYHVY9OqTjaPvi2rGD2O39jO5PF5k1wASxSXTUpqTmZZapG+XQJX
	xr/2f8wF6zkqHu1NbmC8xNbFyMkhIWAiMfvwDWYIW0ziwr31QHEuDiGBpYwSv6fcYIEpmjHj
	PRNEYjqjxNev68ASvAKCEj8m3wOyOTiYBeQljlzKBgkzC6hLTJq3CGyokMBLRom26QkQ5VoS
	j8/MBFvMIqAqca/tAZjNJiAn8bbpGyOILSoQJnF1wnGw8SICyhJXv+9lAdnLLNDIKPH8506w
	ocICHhJrGj6zQiwolFh5YzdYnFPAWOLAowmMIA0SArvYJVYduQ21TUDi2+RDYIdKCMhKbDoA
	9bGkxMEVN1gmMIrNQvLOLIR3ZiF5ZwEj8ypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwKg6
	/e/ZxB2M9w9YH2JMBto4kVlKNDkfGJV5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamDkSUhe0nYsqn+TvFtc50738siTEZq/Tpurb9r/O+l1sbD6
	lyOOD86Z7fvOtOrmZGfDj0ujlr328eN+6PtJm2fP3ci8q9kzX1mbue//8/DrVHeJ6PUiE6bb
	9/3XVcz5kKaxYea+f6xSW1Uv+u9sPRvsM/+8k/GvLZOcuqcedsn5cKw/XPzSH7H5SizFGYmG
	WsxFxYkAFauM58ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoO7VZccDDe4/YrGY+vAJm8XlXXPY
	LD73HmG0aNo+gd3iduMKNgdWj02rOtk8+rasYvQ4fmM7k8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBn/2v8xF6znqHi0N7mB8RJbFyMnh4SAicSMGe+ZIGwx
	iQv31gPFuTiEBKYzSnz9uo4FJMErICjxY/I9IJuDg1lAXuLIpWyQMLOAusSkeYuYQWwhgZeM
	Em3TEyDKtSQen5kJNp9FQFXiXtsDMJtNQE7ibdM3RhBbVCBM4uqE42DjRQSUJa5+38sCspdZ
	oJFR4vnPnWBDhQU8JNY0fGaFWFAosfLGbrA4p4CxxIFHExgnMArMQnLeLITzZiE5bwEj8ypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Jh9JrWDcWWDxSFGAQ5GJR7eH5bHA4VYE8uKK3MP
	MUpwMCuJ8PouBgrxpiRWVqUW5ccXleakFh9iTAb6biKzlGhyPjCd5JXEGxqbmBlZGpkbWhgZ
	m5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4/JIzUezl1x88ddLJNWdeXW61w2Wgo3T
	dGwf9Yn2fQmVW1UnVCjRfkn555eA8w0B3CVsmVUTLVptXJgXqD5wbej21jj1+K2m3xk7K6c+
	sQvvZBb9vnMqofeMp1b95/Zm+2fPbpju4rbdvGEpI0v6TWH7yNsXv818JPmsYZ8UP+/klu+d
	LHd/KLEUZyQaajEXFScCANaw4modAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2013년 06월 22일 00:19, Mark Brown wrote:

> On Thu, Jun 20, 2013 at 04:03:26PM +0900, Jonghwa Lee wrote:
>> This patch adds new regulator driver to support max77693 chip's regulators.
>> max77693 has two linear voltage regulators and one current regulator which
>> can be controlled through I2C bus. This driver also supports device tree.
> 
> This is fine but doesn't have a binding document which is needed for new
> DT bindings.
> 


I'd like to add binding document to max77693 mfd's but it is still in progress
(https://lkml.org/lkml/2013/4/9/221). I think I can updates it when the patch
is merged. Do you think I have to wait for merging? Or just add document under
regulator/ this time ,and then move it to mfd/ later? Which one do you think better?

> A comment in the is_enabled() function explaining that more than one bit
> might be set (or replacing it with the generic function) would also be
> good.


Yes, the charger regulator needs two bits for checking enabling. I'll add the
comment about it.

Thanks,
Jonghwa

