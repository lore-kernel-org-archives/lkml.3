Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3KVJYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:24:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48678 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3KVJX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:23:59 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-26-528f22adde6e
Message-id: <1385112236.29083.3.camel@AMDC1943>
Subject: Re: [PATCH v3 4/5] regulator: max14577: Add regulator driver for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 22 Nov 2013 10:23:56 +0100
In-reply-to: <20131122091639.GG23067@lee--X1>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-5-git-send-email-k.kozlowski@samsung.com>
 <20131122091639.GG23067@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xa7prlfqDDD63mloc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS3ONr1ht7j/9SijxbcrHUwWmx5fY7VY
	2LaExeLyrjlsFmuP3GW3uN24gs1iwvS1LBaHVxxgslj3cjqLxeluVotXB9tYHEQ91sxbw+ix
	4PMVdo8J/Z8YPXbOusvusXL5FzaPzSu0PDat6mTzeLV6JqvHnWt72DzmnQz02Lyk3qNvyypG
	j8+b5Dw2zg0N4IvisklJzcksSy3St0vgyug4f4CtYDlzReO5ZawNjKeYuhg5OSQETCSWHF3A
	CmGLSVy4t56ti5GLQ0hgKaPE2y29jCAJIYHPjBIv+yNBbF4BfYkba46BNQsLhEs0zp7FDGKz
	CRhLbF6+BKiZg0NEQEXi3BtzkDnMAj1sEv1PNoEtYBFQlXi0cgEbiM0poCvRsX05I8SyFYwS
	i65dZwFJMAuoS0yat4gZ4iIlid3tnewQcXmJzWveMkMcISjxY/I9lgmMArOQtMxCUjYLSdkC
	RuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCER/HUH49JjVocYBTgYlXh4d1j2BQmxJpYV
	V+YeYpTgYFYS4a2W6Q8S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBjiVPkpre18Q8ES/nk7xI8u
	4lv7fcHTBx5f55WtkXc/mCP8/Eag6/M5eryXd3m48cVMXH+BJaf2+smNS4V5nZOqH/Mbrzrn
	ObGlp2N2kJRMuPSpuXL8/r+nnsu48P3S7BtNTDu+uc+0EnEqDfn2m/1Z4TULyx9bOJde4VWf
	u+EF99R0y+6Jp3YpsRRnJBpqMRcVJwIA4mVn+b4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 09:16 +0000, Lee Jones wrote:
(...)
> On Fri, 22 Nov 2013, Krzysztof Kozlowski wrote:
> > --- a/include/linux/mfd/max14577.h
> > +++ b/include/linux/mfd/max14577.h
> > @@ -63,7 +63,6 @@ struct max14577_platform_data {
> >  
> >  	int (*set_gpio_pogo_cb) (int new_dev);
> >  
> > -	int num_regulators;
> 
> This doesn't belong in this patch.

Right, thank you.

Krzysztof Kozlowski


