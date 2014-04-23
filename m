Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaDWLw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:52:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49857 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaDWLw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:52:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-bb-5357a995f84e
Content-transfer-encoding: 8BIT
Message-id: <1398253978.3737.2.camel@AMDC1943>
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
Date: Wed, 23 Apr 2014 13:52:58 +0200
In-reply-to: <20140416121814.GD19671@lee--X1>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1> <1397645078.6147.11.camel@AMDC1943>
 <20140416110806.GB19671@lee--X1> <1397646784.6147.18.camel@AMDC1943>
 <20140416121814.GD19671@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xa7pTV4YHG8z6r22xccZ6VoupD5+w
	WVz/8pzV4mzTG3aL+1+PMlp8u9LBZHF51xw2i7VH7rJb3G5cwWZxupvVgctj56y77B6bVnWy
	edy5tofNY97JQI++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKWDf9OWvBFMGK2R+SGhj7eLsY
	OTkkBEwknm26xQRhi0lcuLeeDcQWEljKKPHvnSOIzSsgKPFj8j2WLkYODmYBeYkjl7JBwswC
	6hKT5i1i7mLkAir/zChxeOsmRoh6PYlb/TNZQGxhAWeJFee+gs1nEzCW2Lx8CRvIHBEBFYlz
	b8xBepkFPjNJ7PwIUc8ioCrxpPkFWD2ngK5E/6ndrBD3fGeUOH+wCuJOZYl5+48xTWAUmIXk
	vFkI581Cct4CRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEx8HUH49JjVocYBTgYlXh4
	JZaHBQuxJpYVV+YeYpTgYFYS4V2yKDxYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6P91eibm5Pz
	WHepnffuvyA8q/pje3/Hmx15/6IvZAiduzDjotimb/p1fWrhM+vuOF1YEnk3xt41xeL6UYa7
	kofk4gVfRr+7fa/G3kVgb59+7ZRgNYUXxulKHZb81fcu9a02zLoQ/flJ/3WvvjrX9nAd9dSI
	AgvlNXPsM/ctXBpWvPfoOm8ddyWW4oxEQy3mouJEAIhFUh1fAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 13:18 +0100, Lee Jones wrote:
> > > > > > This is first part of fifth version of patchset adding support for
> > > > > > MAX77836 device to the max14577 driver.
> > > > > > 
> > > > > > I decided to split the patchset into smaller parts. I hope this would
> > > > > > help in getting necessary review/acks from maintainers.
> > > > > > 
> > > > > > The first part introduces changes in max14577 driver and adds support
> > > > > > for MAX77836 in MFD, extcon and regulator drivers. Most of these
> > > > > > patches already have required acks from maintainers.
> > > > > > Full v4 patchset can be found here:
> > > > > > http://thread.gmane.org/gmane.linux.kernel/1654267
> > > > > 
> > > > > So what's the plan for this driver now? What's missing? Do you have
> > > > > all the Acks you need? If so, I'm happy to apply this patch-set and
> > > > > supply a pull-request to the other maintainers.
> > > > 
> > > > Next patches (part 2):
> > > > 1. charger: max14577: Add support for MAX77836 charger
> > > > 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
> > > > 3. regulator/mfd: max14577: Export symbols for calculating charger 
> > > >    current
> > > > 4. charger: max14577: Configure battery-dependent settings from DTS
> > > > 5. Documentation: mfd: max14577: Add device tree bindings document
> > > > 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> > > > 
> > > > They are quite independent from each other so I think it would be the
> > > > best if you could prepare an immutable branch with first part of
> > > > patches.
> > > 
> > > I'm only concerned with the patches in this set at the moment.
> > > 
> > > Do all of the patches in _this_ set have all of the required Acks, or
> > > are you still waiting on some maintainers?
> > 
> > I have all necessary Acks for this patchset.
> > One exception: patch 9/9 (regulator) was only reviewed by Mark Brown,
> > not acked:
> > https://lkml.org/lkml/2014/1/28/252
> 
> That's okay. Still counts. :)

Hi Lee,

If there are no more issues can you apply this patchset and prepare an
immutable branch with them?

Best regards,
Krzysztof

