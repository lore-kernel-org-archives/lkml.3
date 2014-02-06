Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaBFCYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 21:24:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29964 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaBFCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 21:24:23 -0500
X-AuditID: cbfee68e-b7f566d000002344-30-52f2f2551a10
Message-id: <52F2F255.90705@samsung.com>
Date: Thu, 06 Feb 2014 11:24:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-12-git-send-email-k.kozlowski@samsung.com>
 <52F18A08.6070409@samsung.com> <1391596810.3726.5.camel@AMDC1943>
 <20140205140450.GE5196@lee--X1>
In-reply-to: <20140205140450.GE5196@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkRDf006cgg4uTFSymPnzCZvH6haHF
	2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR24PHbOusvusWlVJ5vH
	nWt72DzmnQz02Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyjvzdyFzwRLDi7pWABsbd
	fF2MnBwSAiYSS1fvYYGwxSQu3FvP1sXIxSEksJRR4vabg+wwRU/n/2KGSCxilJg8aycThPOK
	UWJucxszSBWvgIbEqvnvgWwODhYBVYkTb9hAwmwCWhL7X9wAs0UFwiRWTr/CAlEuKPFj8j0W
	kHIRARWJc2/MQUYyC7xhkph4ZiorSI2wgK/E8mlHGUFsIYE3jBK/z/GC2JwCOhJHtl8GW8ss
	oC4xad4iKFteYvOat8wQR39klzh4vxjEZhEQkPg2+RDYLgkBWYlNB6BKJCUOrrjBMoFRbBaS
	i2YhmToLydQFjMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQKj8/S/Z307GG8esD7EmAy0
	ciKzlGhyPjC680riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDI6/Eipvpf7Z9WmrH/WBHdlKnRez12qtvHl0QCfO7/tMyWfzMiVN+p/1V01Y9jonf
	y99ncWtn/oK5K69MdNzdqiFq4fosM/vv3D/5dcIFoo9fOKe0HWHdt+VN6JIZYl13tUy4zxZF
	T1uaHh4+i1X4fe2uF74alv89ur/s22xhYjplTs9mk3vcIUosxRmJhlrMRcWJACDo0tjkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd3QT5+CDHo+SVhMffiEzeL1C0OL
	s01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2ax9shddovbjSvYLE53szpweeycdZfdY9OqTjaP
	O9f2sHnMOxnosXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzDjydyNzwRPBirtXAhoYd/N1MXJySAiYSDyd/4sZwhaTuHBvPVsXIxeHkMAiRonJ
	s3YyQTivGCXmNreBVfEKaEismv8eyObgYBFQlTjxhg0kzCagJbH/xQ0wW1QgTGLl9CssEOWC
	Ej8m32MBKRcRUJE498YcZCSzwBsmiYlnprKC1AgL+Eosn3aUEcQWEnjDKPH7HC+IzSmgI3Fk
	+2WwtcwC6hKT5i2CsuUlNq95yzyBUWAWkhWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZw9D+T3sG4qsHiEKMAB6MSD++G9Z+ChFgTy4orcw8xSnAwK4nwXnwOFOJNSays
	Si3Kjy8qzUktPsSYDAyAicxSosn5wMSUVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2M5RHi/6ueC0ZI3j8SzLL5E8exEsV3bPlV56qdHz3IMVJUON68aL3W
	yn95AlZLJs7O+RBu5yka/6Hxa1FRYNw5jg/7pr+6XF3Yl7C0xnMD9yp126dnK5+7t/5+7LZr
	XuSMhqha976m8Itap+If6nJNXcH7TW6le2BmiuzNClf3v121F92D3zEosRRnJBpqMRcVJwIA
	9603QUIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 11:04 PM, Lee Jones wrote:
>>> Following patch has conflict on extcon-next branch(Linus 3.14-rc1)
>>> when apply patchset by using git am.
>>>
>>> [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
>>> [PATCH 12/18] extcon: max14577: Choose muic_irqs according to device type
>>> [PATCH 14/18] extcon: max14577: Add support for max77836
>>>
>>> The base commit of this patchset isn't mainline. You need to rebase this patchset 
>>> on extcon-next branch and please resend this patchset.
> 
> <snip>
> 
>> This patch patch (along with other) depends on previous rename patches
>> from this patchset:
>> [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to prepare
>> for max77836
>> http://article.gmane.org/gmane.linux.kernel/1636674
>>
>> I can resolve the conflict but then they will return on applying patch
>> 7/18.
>>
>> I think this patch may wait for a little until the rename-like patches
>> will be accepted.
>>
>> Can you ACK other patches touch extcon?
>>  - [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols...
>>  - [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
>>  - [PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and irq_chip
> 
> If you can obtain Acks for all of the patches, I can apply the entire
> patch-set to an immutable branch and issue a pull-request for the
> other maintainers to pull from.
> 

Hi Lee,

OK, I agree your opionion.
I'd like you to apply this patchset dependent on extcon subsytem
on your tree. I acked on following patchset and tested all of this patchset series.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

[PATCH 06/18] extcon: max14577: Change extcon name instead of static name according to device type
- I will delete this patch([PATCH 06/18]) on extcon-next branch.
[PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols...
[PATCH 08/18] mfd: max14577: Rename state container to maxim_core
[PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and irq_chip

[PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
[PATCH 12/18] extcon: max14577: Choose muic_irqs according to device type
[PATCH 14/18] extcon: max14577: Add support for max77836

Thanks,
Chanwoo Choi

