Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3IXJ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:58:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44184 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab3IXJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:58:04 -0400
Date: Tue, 24 Sep 2013 10:58:03 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, lee.jones@linaro.org,
        sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, rob@landley.net,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: arizona: Add device tree binding for
	max_channels_clocked
Message-ID: <20130924095803.GO3635@opensource.wolfsonmicro.com>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1379961043-23762-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5240B4C2.2080600@wwwdotorg.org> <20130923232832.GM21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923232832.GM21013@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 12:28:32AM +0100, Mark Brown wrote:
> On Mon, Sep 23, 2013 at 03:38:10PM -0600, Stephen Warren wrote:
> > On 09/23/2013 12:30 PM, Charles Keepax wrote:
> 
> > > +  - wlf,max-channels-clocked : The maximum number of channels to be clocked on
> > > +    each AIF, useful for I2S systems with multiple data lines being mastered.
> > > +    If specified three cells must supplied one for each AIF, specify zero for
> > > +    AIFs that should be handled normally.
> 
> > What determines the value of this property? Is it really a definition of
> > HW, or some kind of run-time configuration/limit? What goes into each of
> > the 3 cells?
> 
> It's hardware, it's other devices wired in parallel on the bus that use
> the CODEC as a clock master.  Personally I'd have this be set by the
> ASoC machine driver so it's invisible from a DT point of view, that's
> what it's really a property of.

I don't have any really problem with setting this from the
machine driver, I will have a look at doing that.

I think based on the comments here I would suggest that we put
the first patch in but I need to rethink the other patches and
decide what is actually OS independant here.

Thanks,
Charles

