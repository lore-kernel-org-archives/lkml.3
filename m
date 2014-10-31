Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbaJaLpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:45:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32510 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308AbaJaLpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:45:51 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-28-5453766cbee7
Content-transfer-encoding: 8BIT
Message-id: <1414755947.7318.3.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 31 Oct 2014 12:45:47 +0100
In-reply-to: <20141031103217.GJ18557@sirena.org.uk>
References: <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk>
 <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943>
 <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
 <1414741898.20071.8.camel@AMDC1943> <20141031103217.GJ18557@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Nd2csuAQg717DCw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBbnXj1isTj6u8Cid8FVNouzTW/YLe5/Pcpo8e1KB5PFlD/LmSw2
	Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i9PdrA5CHi3NPWwef59fZ/H4u+oFs8fOWXfZPTat
	6mTzuHNtD5vHvJOBHpuX1Hv0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxtq9S1gLDrJX9P/2
	a2D8y9rFyMkhIWAicWfJUnYIW0ziwr31bF2MXBxCAksZJb50L2cESfAKCEr8mHyPpYuRg4NZ
	QF7iyKVskDCzgLrEpHmLmCHqPzNKLHsGMYhXQE/i88btTCC2sIC7xP2Fh8BsNgFjic3Ll7CB
	2CICyhJXv+9lAWlmFjjEJtGx5AAzSIJFQFXi7NrLYNdxAjWs+HuDCWJDM4vE671X2UCukADq
	bux3m8AoMAvJfbMQ7puF5L4FjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi7+sOxqXH
	rA4xCnAwKvHwanwJChFiTSwrrsw9xCjBwawkwvsvPThEiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6O68b4533b7L8v8/V/lctz+R/I9f5OibnCz+99Rlu1QEEt2jT1S37Fmu2P1gpQYodPm57V8
	7kWXWLBJu6XtNTcz4S+UuPbwf6dv6Z+5K2zuMDjMr0yvXK1wLfOOstR8sVyHPdFrZsYu+Vge
	Jjxnx3HFLQ4680JPS08NOPJnP1P7fQHvq1yB55VYijMSDbWYi4oTAYPxB6aaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 10:32 +0000, Mark Brown wrote:
> On Fri, Oct 31, 2014 at 08:51:38AM +0100, Krzysztof Kozlowski wrote:
> 
> > However new DT style parsing (regulator_of_get_init_data()) does the
> > basic parsing stuff and this removes a lot of code from driver. The
> > driver no longer parses all regulaotrs but the regulator core does it.
> > Unfortunately regulator core does not parse custom bindings (like such
> > GPIOs) so I would have to iterate once again through all regulators just
> > to find "gpios" property.
> 
> We could always add a callback for the driver to handle any custom
> properties...  one of the advantages of an OS like Linux is that we can
> improve the core code.

Then I'll add it.

Mark, what device should be assigned to "config.dev" during registration
of regulators? The regulator driver's device or its parent (MFD main
driver)?

Various drivers do this differently.

Best regards,
Krzysztof

