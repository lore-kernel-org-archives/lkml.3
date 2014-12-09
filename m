Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaLIBQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:16:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61301 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:16:22 -0500
X-AuditID: cbfee691-f79b86d000004a5a-70-54864d64d4ad
Message-id: <54864D64.4070002@samsung.com>
Date: Tue, 09 Dec 2014 10:16:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/19] clk: samsung: exynos5433: Add clocks for CMU_G2D
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-6-git-send-email-cw00.choi@samsung.com>
 <54858D2B.3040809@samsung.com>
In-reply-to: <54858D2B.3040809@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWyRsSkQDfVty3EYPMcZovHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG
	+X1ArXf+sVksvX6RyeLU9c9sFou2fmG3OPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6Mb985Cx5yVpz5
	NIe5gfE+excjJ4eEgInEqWu/mSBsMYkL99azdTFycQgJLGWUmNo+n6WLkQOsaOIvbYj4dEaJ
	P3s3sEI4rxklJl5bzA5SxCugJTF/GzPIIBYBVYl5i3ezgthsQOH9L26wgdiiAmESK6dfYQGx
	eQUEJX5MvgdmiwhoS3Revgc2k1ngD7PE6cN7GUESwgIhEsdvvGOCWLaAUWLPl21gHZxAHad3
	3mcCWcwsoCdx/6IWSJhZQF5i85q3zCD1EgJHOCQOPpjCDnGRgMS3yYegvpGV2HSAGeJjSYmD
	K26wTGAUm4XkplkIU2chmbqAkXkVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmA6OP3v2cQd
	jPcPWB9iFOBgVOLh1bBsCxFiTSwrrsw9xGgKdMREZinR5Hxg0skriTc0NjOyMDUxNTYytzRT
	EufVkf4ZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHReqPnRs631/ZP1PH9VLo6Z0/yHc55
	DFf2rwrTEzYPD52xZtt6l8DnO9Nfs5xsinH+Y58m9WnJPtkgv5oXc3aIX0s4LtOhbtoW8WDB
	nfhtt2oW8jMGWeQdX8J+m/fjvPe7dD+8qmIRXlabyu9glBpXuji/qeoYm/HL/VyOF8Xfh73p
	mqYcIn5MiaU4I9FQi7moOBEA3KXw3QIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd0U37YQg5tXzCwer1nMZPF30jF2
	i/fLehgtLu/Xtph/5ByrxZ8JrWwWk+5PYLG48auN1aJ3wVU2i7NNb9gtNj2+xmpxedccNosZ
	5/cBtd75x2ax9PpFJotT1z+zWSza+oXd4vCbdlaLGZNfslms2vWH0eLlxxMsDqIea+atYfT4
	/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih
	6xsSBNdjZIAGEtYwZnz7zlnwkLPizKc5zA2M99m7GDk4JARMJCb+0u5i5AQyxSQu3FvP1sXI
	xSEkMJ1R4s/eDawQzmtGiYnXFoM18ApoSczfxgzSwCKgKjFv8W5WEJsNKLz/xQ02EFtUIExi
	5fQrLCA2r4CgxI/J98BsEQFtic7L98BmMgv8YZY4fXgvI0hCWCBE4viNd0wQyxYwSuz5sg2s
	gxOo4/TO+0wgi5kF9CTuX9QCCTMLyEtsXvOWeQKjwCwkO2YhVM1CUrWAkXkVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnCyeSa1g3Flg8UhRgEORiUeXk3LthAh1sSy4srcQ4wSHMxKIrzL
	d7aGCPGmJFZWpRblxxeV5qQWH2I0BYbARGYp0eR8YCLMK4k3NDYxM7I0Mje0MDI2VxLnVbIH
	miOQnliSmp2aWpBaBNPHxMEp1cCYX5FifrdaTZKdSyFgq8nKAw8Lza7ebi0/VLL87i071uKV
	F983q/VN2LrN1LHl16685oVrojuXJLkoT/co2mfjeviC76Xlm3pMs8Pj/V+XCJ2dLlQZoX//
	y5bbPPdFk+pvez+NXjmhrEB701Jfmw3b3nwKNfibdrp256Ib+38Ifkvl+3hw8pqfSizFGYmG
	WsxFxYkAyKMlX0wDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12/08/2014 08:36 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>> This patch adds ths mux/divider/gate clocksof CMU_G2D domain which includes
> 
> nit: %s/clocksof/clocks of

I'll fix it.

> 
>> G2D/MDMA IPs. The CMU_G2D must need the clocks related to G2D by providing
>> CMU_TOP domain. So, this patch add several clocks for G2D from CMU_TOP domain.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>   .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
>>   drivers/clk/samsung/clk-exynos5433.c               | 144 +++++++++++++++++++++
>>   include/dt-bindings/clock/exynos5433.h             |  42 +++++-
>>   3 files changed, 193 insertions(+), 1 deletion(-)
>>
> 
> Verified all changes in clock file against UM I have with me, all changes are OK.
> 
> With small nit in commit message feel free to add:
> 
> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi


