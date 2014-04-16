Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaDPLCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:02:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38004 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaDPLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:02:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-9d-534e6355cad9
Content-transfer-encoding: 8BIT
Message-id: <1397646165.6147.16.camel@AMDC1943>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 16 Apr 2014 13:02:45 +0200
In-reply-to: <534E60C6.4080005@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1> <1397645078.6147.11.camel@AMDC1943>
 <534E60C6.4080005@samsung.com>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xa7qhyX7BBpNvKVpsnLGe1WLqwyds
	Fte/PGe1ONv0ht3i/tejjBbfrnQwWVzeNYfNYu2Ru+wWtxtXsFmc7mZ14PLYOesuu8emVZ1s
	Hneu7WHzmHcy0KNvyypGj8+b5ALYorhsUlJzMstSi/TtErgytpy7xVSwXbjiyu+LzA2MR/i7
	GDk5JARMJBase8wEYYtJXLi3nq2LkYtDSGApo8S777NZQRK8AoISPybfY+li5OBgFpCXOHIp
	GyTMLKAuMWneImaI+s+MEs939kDV60t8WLiNDcQWFnCWWHHuK9gCNgFjic3Ll4DFRQQ0JGb+
	vcII0sws8J5J4tma+2BFLAKqEj8fNIMVcQpoSzxceh/qonWMEntfvIc6VUni3Lo1jBMYBWYh
	OXAWwoGzkBy4gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZILHzdwbj0mNUhRgEORiUe
	3hk5vsFCrIllxZW5hxglOJiVRHgbI/2ChXhTEiurUovy44tKc1KLDzEycXBKNTB6n8pVtxEx
	mGV5K8b1YTf3+80Vs6ym6i75wdOWeS4qhffQwy9rQrMyg9/vm7/6/3/JRQvFNLfUbtHc2Nqy
	//H9qirfpkNf/ZqelEwxMVYM/LhZoTj14ZK/Ru2L8rcYOaRNsNuS8amPyV59PdPpRwc9/9jJ
	VrgXqvRsZdbemG9r/noS69enejZKLMUZiYZazEXFiQDQxzoxYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 19:51 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> On 04/16/2014 07:44 PM, Krzysztof Kozlowski wrote:
> > On śro, 2014-04-16 at 11:28 +0100, Lee Jones wrote:
> >>> This is first part of fifth version of patchset adding support for
> >>> MAX77836 device to the max14577 driver.
> >>>
> >>> I decided to split the patchset into smaller parts. I hope this would
> >>> help in getting necessary review/acks from maintainers.
> >>>
> >>> The first part introduces changes in max14577 driver and adds support
> >>> for MAX77836 in MFD, extcon and regulator drivers. Most of these
> >>> patches already have required acks from maintainers.
> >>> Full v4 patchset can be found here:
> >>> http://thread.gmane.org/gmane.linux.kernel/1654267
> >>
> >> So what's the plan for this driver now? What's missing? Do you have
> >> all the Acks you need? If so, I'm happy to apply this patch-set and
> >> supply a pull-request to the other maintainers.
> > 
> > Next patches (part 2):
> > 1. charger: max14577: Add support for MAX77836 charger
> > 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
> > 3. regulator/mfd: max14577: Export symbols for calculating charger 
> >    current
> > 4. charger: max14577: Configure battery-dependent settings from DTS
> > 5. Documentation: mfd: max14577: Add device tree bindings document
> > 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> > 
> > They are quite independent from each other so I think it would be the
> > best if you could prepare an immutable branch with first part of
> > patches.
> 
> I have to modify all extcon device drivers for some reason,
> If your patchset including extcon patch apply other git repository,
> this patchset may have potential merge conflict.
> 
> If you possible, following patchset would divide two patchset for each mfd/extcon
> to remove potential merge conflict in 3.15 merge window.
> - [PATCH v5 0/9] mfd: max14577: Add support for MAX77836

I think we can resolve this after preparing by Lee the immutable branch
with this patches. You could pull it so your changes to extcon-max14577
would be on newest version.

It would be difficult to split this part1 patchset into two patchsets
because the changes in extcon driver depend on changes in headers for
IRQ-s. Only the patch:
 - [PATCH v5 8/9] extcon: max14577: Add support for MAX77836
could be easily taken out and split.

Best regards,
Krzysztof



