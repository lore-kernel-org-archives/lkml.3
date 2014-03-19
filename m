Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244AbaCSNP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:15:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19443 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229AbaCSNP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:15:56 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-b3-5329988978b2
Message-id: <1395234951.7642.1.camel@AMDC1943>
Subject: Re: [PATCH v3 2/3] mfd: sec-core: Add of_compatible strings for clock
 MFD cells
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Wed, 19 Mar 2014 14:15:51 +0100
In-reply-to: <20140318203159.GW25478@lee--X1>
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
 <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
 <20140318203159.GW25478@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xK7qdMzSDDWY8NbPYOGM9q8XZpjfs
	Fve/HmW02PT4GqvF5V1z2CxmnN/HZLH2yF12i6cTLrJZnPzTy2hxupvV4uKKL0wW62e8ZrFo
	/7uXzWLO9HdMDnwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKaD60
	kaXgHEtF0webBsYXzF2MnBwSAiYSR/p7WCFsMYkL99azdTFycQgJLGWU2LtpBzOE85lRYnnr
	XKAqDg5eAT2JHR+UQRqEBaIkZkztARvEJmAssXn5EjaQEhEBFYlzb8xBWpkF5rJIbOh/ClbD
	IqAqMX/fG7AaTgFdiVv9/BDjVzBK/F52kw2khllAXWLSvEVQxylJ7G7vZIeIy0tsXvMWLM4r
	ICjxY/I9lgmMArOQtMxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEx8mUH
	4+JjVocYBTgYlXh4JWM1goVYE8uKK3MPMUpwMCuJ8P6aohksxJuSWFmVWpQfX1Sak1p8iJGJ
	g1OqgVHrVoD+PZNzFhNNHtZcn/yJweDmuX+/Et4eZbyy+HQ/u3O8lNTplUWR4uYB/WsVVjKp
	FoiFXK689sVGZFfL5x1Xa0/v9AvPS5spsaVK9ndyuKPEki2OR/w0tZnmeh0PZV4pGerlzVxa
	OTlE6Il0X0/xIvkbN/a5ONxwWHCp6s3703maZxstPZVYijMSDbWYi4oTAYLqh4pvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 20:31 +0000, Lee Jones wrote:
> > Add of_compatible strings for S5M8767 and S2MPS14 clock MFD cells.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c |    3 +++
> >  1 file changed, 3 insertions(+)
> 
> Applied with Tomasz' Reviewed-by.

Thanks! One minor thing - I see that Tomasz' Review-by got lost when the
patch was applied to your tree:
https://git.kernel.org/cgit/linux/kernel/git/lee/mfd.git/commit/?h=for-mfd-next&id=09f8c0a07044bb8ac5085fcbcf82468173a1666d.

Best regards,
Krzysztof

