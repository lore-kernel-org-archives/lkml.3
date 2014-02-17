Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaBQIJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:09:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30965 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaBQIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:09:50 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-74-5301c3cb14fc
Message-id: <1392624586.3755.13.camel@AMDC1943>
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Mon, 17 Feb 2014 09:09:46 +0100
In-reply-to: <20140214205915.GW4451@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <20140213192835.GD28112@sirena.org.uk> <1392365712.29133.16.camel@AMDC1943>
 <20140214205915.GW4451@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7qnDzMGG3z8qm2xccZ6VoupD5+w
	WVz/8pzV4mzTG3aL+1+PMlp8u9LBZHF51xw2ixnn9zFZrD1yl93idDerxcUVX5gcuD12zrrL
	7rFpVSebx51re9g85p0M9OjbsorR4/MmuQC2KC6blNSczLLUIn27BK6MmZ8OMRbsZ6/Yv2km
	awPjW9YuRk4OCQETib1/N7NA2GISF+6tZ+ti5OIQEljKKLFxGojDCeR8ZpQ4ucgYxOYV0Jfo
	u7QGrEFYIFTi0rofYDabgLHE5uVLwOpFBJQlrn7fywIyiFlgErPEn5PdTCAJFgFViZvP5jCC
	2JwCRhLfF99jgtj2h1Gi58gbsEnMAuoSk+YtYoY4SUlid3snO0RcXmLzmrfMEFcISvyYfI9l
	AqPALCQts5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSFx82cG4+JjVIUYB
	DkYlHl6DasZgIdbEsuLK3EOMEhzMSiK8tuuAQrwpiZVVqUX58UWlOanFhxiZODilGhitvj2f
	vt7f+GrWBaljO8yTnNWzo09PTGbfKNcYJzkhWTN6yuPT181ntiWyf/82ZUOo2THjlSuOJd5+
	8Dh+vkSn4dWSlA8CMyWdFgj1nLk83eahh9KRfRt/NX/doq/5/8umJ6/1Jn6JzT+X8/rR5+KI
	x0ePfDJa4/hUWe+00vuShB2/5u8Oyv6TrsRSnJFoqMVcVJwIACYRUwRpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 20:59 +0000, Mark Brown wrote:
> On Fri, Feb 14, 2014 at 09:15:12AM +0100, Krzysztof Kozlowski wrote:
> 
> > My initial idea was to do this similarly to the S5M8767 regulator (where
> > there is also 4th mode: low power). The presence of GPIO in DTS can
> > simplify the bindings but on the other hand it wouldn't be compatible
> > with S5M8767 regulator driver. This may complicate the merge of these
> > drivers.
> 
> They can always use separate ops.
> 
> > What is your opinion on this - should I abandon the "op_mode" idea and
> > use presence of GPIO?
> 
> Yes, that's better - especially since the framework has support for
> enable GPIOs.  It can do things like handle cases where the hardware has
> tied the enables for several regulators together so they all need to be
> enabled and disabled as one.

OK. I'll rewrite this patch and send later when S2MPS14 will be
accepted.

Best regards,
Krzysztof

