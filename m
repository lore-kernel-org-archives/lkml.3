Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaDPLNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:13:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47375 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaDPLNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:13:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-27-534e65bfd2f0
Content-transfer-encoding: 8BIT
Message-id: <1397646784.6147.18.camel@AMDC1943>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 16 Apr 2014 13:13:04 +0200
In-reply-to: <20140416110806.GB19671@lee--X1>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1> <1397645078.6147.11.camel@AMDC1943>
 <20140416110806.GB19671@lee--X1>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7r7U/2CDdYsN7fYOGM9q8XUh0/Y
	LK5/ec5qcbbpDbvF/a9HGS2+Xelgsri8aw6bxdojd9ktbjeuYLM43c3qwOWxc9Zddo9NqzrZ
	PO5c28PmMe9koEffllWMHp83yQWwRXHZpKTmZJalFunbJXBlzP+9nLlgH39F56pDLA2Mk3m6
	GDk4JARMJHofZnUxcgKZYhIX7q1n62Lk4hASWMoosbFhEztIgldAUOLH5HssIPXMAvISRy5l
	g4SZBdQlJs1bxAxR/5lR4saRq0wQ9foST3dcAOsVFnCWWHHuK1icTcBYYvPyJWwgc0QEVCTO
	vTEH6WUW+MwksfPjTBaQGhYBVYlFh66A1XMK6ErMf/KHFWLBBkaJ/iUT2SEuVZI4t24N4wRG
	gVlI7puFcN8sJPctYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESB193MC49ZnWIUYCD
	UYmHd0aOb7AQa2JZcWXuIUYJDmYlEd7GSL9gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzFU3UN
	RHtjhE6z1Zf5SX3ddu+TvNfMC3m/z2kUBDaZH/FTTRI4US65dN+ES1tj/SOVPv/fI5PsuM9u
	Xv8du/kb/3d5/Hz73VjvT/1jxWgrMckOAbtb9a+ecmvyW4tXlC2dcnpbvO2UnnxZxTlPFr+U
	ee0hmPz0VOujc2fWSn/cNy3/2/KiRkUlluKMREMt5qLiRAA+TutOYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 12:08 +0100, Lee Jones wrote:
> On Wed, 16 Apr 2014, Krzysztof Kozlowski wrote:
> 
> > On śro, 2014-04-16 at 11:28 +0100, Lee Jones wrote:
> > > > This is first part of fifth version of patchset adding support for
> > > > MAX77836 device to the max14577 driver.
> > > > 
> > > > I decided to split the patchset into smaller parts. I hope this would
> > > > help in getting necessary review/acks from maintainers.
> > > > 
> > > > The first part introduces changes in max14577 driver and adds support
> > > > for MAX77836 in MFD, extcon and regulator drivers. Most of these
> > > > patches already have required acks from maintainers.
> > > > Full v4 patchset can be found here:
> > > > http://thread.gmane.org/gmane.linux.kernel/1654267
> > > 
> > > So what's the plan for this driver now? What's missing? Do you have
> > > all the Acks you need? If so, I'm happy to apply this patch-set and
> > > supply a pull-request to the other maintainers.
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
> I'm only concerned with the patches in this set at the moment.
> 
> Do all of the patches in _this_ set have all of the required Acks, or
> are you still waiting on some maintainers?

I have all necessary Acks for this patchset.
One exception: patch 9/9 (regulator) was only reviewed by Mark Brown,
not acked:
https://lkml.org/lkml/2014/1/28/252



