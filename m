Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab3ECMEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:04:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43504 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3ECMET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:04:19 -0400
Date: Fri, 3 May 2013 07:03:50 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Kevin Hilman <khilman@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>
Subject: Re: [PATCH v3 1/5] regulator: Introduce TI Adaptive Body Bias(ABB)
 on-chip LDO driver
Message-ID: <20130503120349.GA2735@snafu>
References: <1367515215-30753-1-git-send-email-nm@ti.com>
 <1367515215-30753-2-git-send-email-nm@ti.com>
 <20130503090258.GG4945@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130503090258.GG4945@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On 10:02-20130503, Mark Brown wrote:
> On Thu, May 02, 2013 at 12:20:10PM -0500, Nishanth Menon wrote:
> > From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>
> > 
> > Adaptive Body Biasing (ABB) modulates transistor bias voltages
> > dynamically in order to optimize switching speed versus leakage.
> 
> I've applied this but please note that I still have deep concerns about
> some of the discussion about controlling this from other regulators.
Thanks for the merge.

We don't have any further plans of pursuing the concept of regulator
chaining for upstream. After an off-line chat with Mike T, we are
planning on introducing OMAP specific notifier hooks to clock
framework. This should allow us to do the appropriate sequencing
necessary to control AVS, regulators for ABB and PMIC in the right
sequence.

-- 
Regards,
Nishanth Menon
