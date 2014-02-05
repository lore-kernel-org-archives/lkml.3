Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaBEKqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:46:04 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63705 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaBEKqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:46:02 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-aa-52f216679c67
Message-id: <1391597158.3726.10.camel@AMDC1943>
Subject: Re: [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to
 prepare for max77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 11:45:58 +0100
In-reply-to: <20140203093809.GH13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
 <20140203093809.GH13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7rpYp+CDG63yFhMffiEzeL6l+es
	FpOevGe2mLhyMrPF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR14
	PHbOusvusXmFlsemVZ1sHneu7WHzmHcy0GPzknqPvi2rGD0+b5IL4IjisklJzcksSy3St0vg
	ymh5f4i9YBt3RdcE5wbGFs4uRg4OCQETiW+f3bsYOYFMMYkL99azdTFycQgJLGWU2Ln8MyNI
	QkjgM6PExS9FIDavgL7Elr5fTCC2sECyxMcDF9hAbDYBY4nNy5eANYsIHGOUWHLtEZjDLDCL
	SeLZgdvsIFUsAqoSk9e+AevmFNCVuHf6BdS6FYwSd7e/YgVJMAuoS0yat4gZ4iYlid3tnewQ
	cXmJzWveMkOcISjxY/I9lgmMArOQtMxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGCHx8nUH49JjVocYBTgYlXh4DYQ/BgmxJpYVV+YeYpTgYFYS4W0U+BQkxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgXFFq97C4uItEq9lNxd5H3+8cWHIyuPW4rv2nvRONq4q2/KmZ/bieR37
	hYz1JY82vj1zZ6rMRZt2oU3HQlK/O66IYKt+xdbRODF5lYSiQePj03NYqoN7v1lsX1ut+1x1
	25zZ3UcDy2ddFMqN/p2s1Dd/+qVvxTe+1x1q8Ix+wVlSzCF5ZK7sontKLMUZiYZazEXFiQBT
	8wHedQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for ACK.

Dear Chanwoo, Mark and Dmitry, can you ACK this patch and also 8/18 and
9/18:
http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674
http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674
?

Best regards,
Krzysztof

On Mon, 2014-02-03 at 09:38 +0000, Lee Jones wrote:
> > This patch prepares for adding support for max77836 device to existing
> > max14577 driver:
> > 1. Renames most of symbols and defines prefixed with MAX14577 to MAXIM.
> > 2. Adds prefixes (MAXIM or MAX14577) to defines without any MAX* prefix.
> > 
> > This is only a rename-like patch, new code is not added.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/extcon/extcon-max14577.c     |  105 ++++-----
> >  drivers/mfd/max14577.c               |   51 ++---
> >  drivers/power/max14577_charger.c     |   81 +++----
> >  drivers/regulator/max14577.c         |   44 ++--
> >  include/linux/mfd/max14577-private.h |  399 ++++++++++++++++------------------
> >  include/linux/mfd/max14577.h         |    2 +-
> >  6 files changed, 333 insertions(+), 349 deletions(-)
> 
> I think the name changes instil some clarity here.
> 
> I still need the other Acks before applying the patch though.
> 
> For now you can have my:
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 

