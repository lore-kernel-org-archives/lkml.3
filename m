Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaBTIyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:54:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55681 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaBTIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:54:51 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f6-5305c2d809b4
Message-id: <1392886487.3648.12.camel@AMDC1943>
Subject: Re: [PATCH v3 02/15] mfd: max14577: Rename and add MAX14577 symbols to
 prepare for max77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Thu, 20 Feb 2014 09:54:47 +0100
In-reply-to: <20140219141102.GA2669@sirena.org.uk>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-3-git-send-email-k.kozlowski@samsung.com>
 <1392813881.17652.14.camel@AMDC1943> <20140219141102.GA2669@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xK7o3DrEGG0xvs7A4uFXTYuOM9awW
	Ux8+YbO4/uU5q8WkJ++ZLSaunMxscbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJb3G5cwWZx
	upvVYv2M1ywOfB4T+j8xeuycdZfdY/MKLY9NqzrZPO5c28PmMe9koMfmJfUefVtWMXp83iQX
	wBnFZZOSmpNZllqkb5fAlTF9+Vf2goscFR2HzzM3ML5g62Lk5JAQMJHoOnEZyhaTuHBvPZDN
	xSEksJRR4tiWt0wQzmdGiffP/zOBVPEK6Es86dvIAmILC6RJXFx4nBHEZhMwlti8fAnYJBEB
	ZYmr3/eygDQzC0xjkfjYvoIdJMEioCrx6usPsAZOASOJdRPWsEJsuMQo0bFzF1g3s4C6xKR5
	i5ghblKS2N3eyQ4Rl5fYvOYtM8QVghI/Jt9jmcAoMAtJyywkZbOQlC1gZF7FKJpamlxQnJSe
	a6hXnJhbXJqXrpecn7uJERJPX3YwLj5mdYhRgINRiYc34jpLsBBrYllxZe4hRgkOZiURXp5M
	1mAh3pTEyqrUovz4otKc1OJDjEwcnFINjClNew8XTL7K8+2ZPkPsySuHBQKmffHgWm5zM+3N
	/8uPb4iGfXtf7Zqy8niA8nQ34T8fz4Q9cZGTFTCYtn1x1KlUVY4PTveML28xelERNu1ATvjB
	aRsctjM1/D32Id75+6ypurUn7Wfu3FIfKWEwZd97Q4cP2Wf2WE77ZCt5sKlNMr3sxJkbfT5K
	LMUZiYZazEXFiQBs+GmUhQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 23:11 +0900, Mark Brown wrote:
> On Wed, Feb 19, 2014 at 01:44:41PM +0100, Krzysztof Kozlowski wrote:
> 
> > I want to push whole MAX77836 patchset through Lee Jones' MFD tree and I
> > still need acks from power and regulator subsystems.
> 
> > I would appreciate if you could find time to look at these patches and
> > let me know your opinion (or just add Acked-by):
> > [PATCH v3 02/15] mfd: max14577: Rename and add MAX14577 symbols...
> > [PATCH v3 03/15] mfd: max14577: Rename state container to maxim_core
> > [PATCH v3 04/15] mfd: max14577: Add "muic" suffix to regmap and irq_chip
> 
> I don't have these patches, I expect it looked like the series was going
> to get a respin.

Hmmm, I'll send the next version of this patchset.

> 
> To be honest the number of large patch serieses you've been sending
> iterations of (sometimes partial series without context too) doesn't
> push them up the priority list, it'd help to rate limit things a bit.

I understand, especially that such drivers touch multiple subsystems.

Best regards,
Krzysztof


