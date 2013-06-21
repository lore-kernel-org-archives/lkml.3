Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030464Ab3FUOMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:12:08 -0400
Received: from smtp.nfit.au.dk ([130.225.17.180]:47514 "EHLO nysmtp.nfit.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030372Ab3FUOMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:12:06 -0400
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/3] mfd: Add irq domain support for max8998
 interrupts
References: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
	<1371818017-5215-2-git-send-email-t.figa@samsung.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Organization: D03
Date: Fri, 21 Jun 2013 14:12:02 +0000
In-Reply-To: <1371818017-5215-2-git-send-email-t.figa@samsung.com> (Tomasz
 Figa's message of "Fri, 21 Jun 2013 14:33:35 +0200")
Message-ID: <u0l61x7a6z1.fsf@orc04.imf.au.dk>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa <t.figa@samsung.com> writes:

> All uses of irq_base in platform data and max8997 driver private data
> are removed.
>
[...]
> +static int max8998_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +					irq_hw_number_t hw)
> +{
> +	struct max8997_dev *max8998 = d->host_data;

I may be wrong, but this sure looks like a typo (or copy-pasto).

-- 
Rasmus Villemoes
<http://rasmusvillemoes.dk/>
