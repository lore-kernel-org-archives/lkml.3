Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaA2K3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:29:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13335 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2K3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:29:09 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-61-52e8d7f22dd5
Message-id: <1390991344.2207.8.camel@AMDC1943>
Subject: Re: [PATCH RESEND 1/4] clk: clk-s2mps11: Refactor for including
 support for  other MFD clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Kgene Kim <kgene.kim@samsung.com>,
        Patch Tracking <patches@linaro.org>, Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>
Date: Wed, 29 Jan 2014 11:29:04 +0100
In-reply-to: <mvd17-4vW-3@gated-at.bofh.it>
References: <m8Uox-5kN-11@gated-at.bofh.it> <mtgmt-44E-3@gated-at.bofh.it>
 <mtgmu-44E-27@gated-at.bofh.it> <muwSe-WJ-17@gated-at.bofh.it>
 <muCkW-RP-15@gated-at.bofh.it> <mva3f-bR-7@gated-at.bofh.it>
 <mvd17-4vW-3@gated-at.bofh.it>
References: <m8Uox-5kN-11@gated-at.bofh.it> <mtgmt-44E-3@gated-at.bofh.it>
 <mtgmu-44E-27@gated-at.bofh.it> <muwSe-WJ-17@gated-at.bofh.it>
 <muCkW-RP-15@gated-at.bofh.it> <mva3f-bR-7@gated-at.bofh.it>
 <mvd17-4vW-3@gated-at.bofh.it>
In-reply-to: <mvd17-4vW-3@gated-at.bofh.it>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xa7qfrr8IMlj8TcFi6sMnbBa9C66y
	Wdz/epTRYtPja6wWl3fNYbOYcX4fk8XTCRfZLKYc/sJi0f53L5sDp8emVZ1sHneu7WHz2Lyk
	3qNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgylhxsZSn4w1Zx/n8nSwPjFtYuRg4OCQETiau7
	DbsYOYFMMYkL99azgdhCAksZJV5v1Oti5AKyPzNKHNj0mAWknldAT+LoOhGQGmGBDIlrN96y
	gthsAsYSm5cvAesVEdCS2HaglQ2kl1ngDZPE3LXrmEASLAKqEtemnQQr4hTQlvg5dRs7xLLX
	jBLr+2zQ2chqmAXUJSbNW8QMcaiSxO72Tqi4vMTmNW/B4rwCghI/Jt9jmcAoNAtJyywkZbOQ
	lC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERIlX3cwLj1mdYhRgINRiYd3w43nQUKs
	iWXFlbmHGCU4mJVEeBkuvQgS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMhRudxh4b6QvphW164O
	85Ki+flFdh/u7MvJMFt24VbZmRO71mVe/HP09KqXN4M/Xk3gZVVKv3TQ4Z3V6U8bQqqOL/PZ
	qS821WfpBO2VD7u3ft5zXEXp7LFdbPkdi4O27H21X6JR02vR4apHDysvm3zj233aRH39ITYv
	z0PyFTZvZ4touFgJ6LEpsRRnJBpqMRcVJwIAhaodX3ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> Quoting Mark Brown (2013-12-31 08:09:16)
> > On Mon, Dec 30, 2013 at 09:33:50AM +0530, Tushar Behera wrote:
> > 
> > > Commit 1b1ccee1e821 "mfd: s2mps11: Fix build after regmap field rename
> > > in sec-core.c" is also touching this file, which is in Mark's tree
> > > right now. If I rebase
> > 
> > It's been in Linus' tree for a while now.
> 
> OK, so I merged the two patches into clk-next, then merged clk-next into
> next-20131224 and the merge is super trivial to resolve. So I propose
> that we just let it get resolved in linux-next the usual way.
> 
> Any objections? If not I'll take these two patches into clk-next.

Did you merged these patches into clk-next? Unfortunately I couldn't
find them (clk-next, next).

I am asking because I want to send patches with support for S2MPS14
clock (based on these patches).

Best regards,
Krzysztof


