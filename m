Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaBZE7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:59:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54839 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaBZE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:59:34 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-57-530d74b2d12e
Message-id: <530D787F.9080501@samsung.com>
Date: Wed, 26 Feb 2014 14:15:43 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: samsung: remove parentheses from return statements
References: <1393382688-5429-1-git-send-email-pankaj.dubey@samsung.com>
 <CAK9yfHyjQmFnJaM0v638X-K+jHveofOkf=2bWQ9-cyQ1y39Hmw@mail.gmail.com>
In-reply-to: <CAK9yfHyjQmFnJaM0v638X-K+jHveofOkf=2bWQ9-cyQ1y39Hmw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zfd1NJbzBBp3vmSw2Pb7GanF51xw2
	ixnn9zFZPJ1wkc3i5J9eRov1M16zOLB53Lm2h81j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo4u2cKe8FGlorXj/6xNDCeZe5i5OSQEDCR+PFgHRuELSZx4d56IJuLQ0hgGaPEnpaJ
	bDBFE+80skMkFjFKNG9dwwLhvGaU6L/2gR2kildAS6LpwXdGEJtFQFVi4fKVrCA2m4CuxJP3
	c8HWiQqESWya3scKUS8o8WPyPRYQWwSo92X3ciaQocwCzxklfv1ZCJYQFvCRmHbxBRPEtj5G
	idOXX4PdxCkQLHH2ShvYZmYBa4mVk7YxQtjyEpvXvGUGaZAQOMQuMfvCSyaIkwQkvk0+BDSV
	AyghK7HpADQAJCUOrrjBMoFRbBaSo2YhGTsLydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS
	83M3MULibOIOxvsHrA8xJgOtnMgsJZqcD4zTvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgrCn41vmwZZLQN75j/yV/uJ+a7HzB6FHYfKlJlRzB
	FVO6H/5OvpMx99I8tcqZboZ/BUxjPmbYuhmK/9mZ7ax9yEvyJvv9mVunVDseduo+zl2/6Nf2
	Bo/vNuqOOeJSh033BOX9XJCbdEVEzuCBVwr/nZ3fM8qqjT4nNBREXeK+d/qNwvOlAhPUlViK
	MxINtZiLihMB3Sxec8kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd2NJbzBBpM+WFtsenyN1eLyrjls
	FjPO72OyeDrhIpvFyT+9jBbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcXbPFPaCjSwVrx/9Y2lgPMvcxcjJISFgIjHx
	TiM7hC0mceHeerYuRi4OIYFFjBLNW9ewQDivGSX6r30Aq+IV0JJoevCdEcRmEVCVWLh8JSuI
	zSagK/Hk/VywqaICYRKbpvexQtQLSvyYfI8FxBYB6n3ZvZwJZCizwHNGiV9/FoIlhAV8JKZd
	fMEEsa2PUeL05ddsIAlOgWCJs1fawDYzC1hLrJy0jRHClpfYvOYt8wRGgVlIlsxCUjYLSdkC
	RuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFR/Ex6B+OqBotDjAIcjEo8vAEsvMFCrIll
	xZW5hxglOJiVRHils4FCvCmJlVWpRfnxRaU5qcWHGJOBYTCRWUo0OR+YYPJK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXFK9KlHF4Kf7XrPIPrXu1M9bX3O
	4lmBUX9NegXfLy1Zc6lX+Pd6+TcHa4stFvrtfc3XWuu2zGaGwcFjv69FGn3f9aM45/qVPC67
	72pJPPacDhe0Kx8v6fL4ITlbY8tjq2X9Ndd2if/Je+TV+s5l1TX9mdW1oaInrn6OeW0p95rR
	b/ap2CPsa62VWIozEg21mIuKEwGMvE0mJgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 02/26/2014 01:12 PM, Sachin Kamat wrote:
> Hi Pankaj,
>
> On 26 February 2014 08:14, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> fixed following checkpatch warning message
>> "return is not a function, parentheses are not required"
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Similar patch has already been submitted:
> http://comments.gmane.org/gmane.linux.ports.arm.kernel/294530
>
>
Sorry I missed that.
Since same change already submitted we can ignore my patch.

-- 
Best Regards,
Pankaj Dubey

