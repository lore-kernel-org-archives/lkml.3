Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaJ0Ktq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:49:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29338 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0Kto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:49:44 -0400
X-AuditID: cbfee68d-f79296d000004278-f0-544e23469de5
Message-id: <544E2346.9000908@samsung.com>
Date: Mon, 27 Oct 2014 19:49:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/2] clk: samsung: Add clock controller driver for
 Exynos4415 SoC
References: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
 <544E20E3.5030609@samsung.com>
In-reply-to: <544E20E3.5030609@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkRNdN2S/EoPOImsWfCa1sFpPuT2Cx
	6F1wlc3ibNMbdovLu+awWcw4v4/J4vCbdlaLGZNfslms2vWH0YHTY+esu+wefVtWMXp83iQX
	wBzFZZOSmpNZllqkb5fAlfFqVkjBB+aKkystGhj7mLsYOTkkBEwkOr6thLLFJC7cW88GYgsJ
	LGWUePrDEaZmxeZFQDVcQPHpjBIrb55mg3BeM0qcPzSdCaSKV0BLYv2/FewgNouAqsTS/nVg
	cTag+P4XN8CmigqESaycfoUFol5Q4sfke2C2iIC+xJJVF8GGMgtcZ5T482se2EnCApESB+a1
	M0GclCLxfcFjMJtTQFti8Zb9QM0cQA16EvcvaoGEmQXkJTaveQt2qYTAMXaJ1Qsvs0AcJCDx
	bfIhsHoJAVmJTQegPpaUOLjiBssERrFZSE6ahTB1FpKpCxiZVzGKphYkFxQnpRcZ6hUn5haX
	5qXrJefnbmIERtzpf896dzDePmB9iFGAg1GJh9ei0DdEiDWxrLgy9xCjKdARE5mlRJPzgXGd
	VxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/XxyB91
	LgJ27cuqdsznKun1FD99+uiCPtbedTZePyQ7bpxsi7gtf7t6YuWzU/oK33cuu+0pzzEjp75F
	2zAwpC7RQOHXykuMcWm1L5d4NgqWmE26ezJlr7rujLxQ8cCPws+CmKQOzL2tVrrg30bHJ8bS
	W3zuxZ389c8nWj1rXky+2h3zzb+4lViKMxINtZiLihMBSGBUD7MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQV03Zb8Qg56J8hZ/JrSyWUy6P4HF
	onfBVTaLs01v2C0u75rDZjHj/D4mi8Nv2lktZkx+yWaxatcfRgdOj52z7rJ79G1ZxejxeZNc
	AHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMV7NCCj4wV5xcadHA2Mfc
	xcjJISFgIrFi8yIoW0ziwr31bF2MXBxCAtMZJVbePA3lvGaUOH9oOhNIFa+AlsT6fyvYQWwW
	AVWJpf3rwOJsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkemC0ioC+xZNVFsKHMAtcZJf78mge2
	WlggUuLAvHawQUICKRLfFzwGszkFtCUWb9kP1MwB1KAncf+iFkiYWUBeYvOat8wTGAVmIVkx
	C6FqFpKqBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/qZ1A7GlQ0WhxgFOBiVeHgt
	Cn1DhFgTy4orcw8xSnAwK4nwOv4ECvGmJFZWpRblxxeV5qQWH2I0BQbARGYp0eR8YLLJK4k3
	NDYxM7I0Mje0MDI2VxLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAqPxt9zuP+fJTZ/5lUpbP
	Wr84a+2HWt3+NTM/NP7Jt6mp3pDvbPWqYH2q/eQ1L2/kLhRsyO60D0jYlDvXxP/Ckg2R5rN9
	IkX/ZfGqNk4qkXyocWPXY7aJnmwnMtQTP7bejcrjacu4/eifsElwvMbKJ+pRJZE9E7dtUm2d
	dYeV2V3SO2G7uOdlJZbijERDLeai4kQAKxdHPf4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 07:39 PM, Sylwester Nawrocki wrote:
> On 27/10/14 02:11, Chanwoo Choi wrote:
>> Chanwoo Choi (2):
>>   clk: samsung: exynos4415: Add clocks using common clock framework
>>   clk: samsung: Document binding for Exynos4415 clock controller
> 
> Added both to my tree, thanks. In future please put DT binding
> documentation first in the series, before the actual driver patch.

I'll put the documentation patch first in the patchset. Thanks.

Best Regards,
Chanwoo Choi

