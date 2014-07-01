Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbaGAIiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:38:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47688 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbaGAIiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:38:01 -0400
Date: Tue, 1 Jul 2014 09:37:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Dan Murphy <dmurphy@ti.com>,
        "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] ASoC: tas2552: Support TI TAS2552 Amplifier
Message-ID: <20140701083749.GH28740@leverpostej>
References: <1404148259-17305-1-git-send-email-dmurphy@ti.com>
 <20140630172115.GE28740@leverpostej>
 <20140630214342.GI23300@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630214342.GI23300@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:43:42PM +0100, Mark Brown wrote:
> On Mon, Jun 30, 2014 at 06:21:15PM +0100, Mark Rutland wrote:
> > On Mon, Jun 30, 2014 at 06:10:59PM +0100, Dan Murphy wrote:
> 
> > > +Optional properties:
> 
> > > +- power-gpio - gpio pin to enable/disable the device
> 
> > The code below seems to look for "enable-gpio". Searching for
> > "power-gpio" only hits in the line above and the example below. I assume
> > the code is in error?
> 
> It depends what this is for - if it's for an external regulator it
> should be a regulator binding.  Also all GPIO properties
> are supposed to be called -gpios because DT conventions.

Sure. I was commenting on the mismatch between "enable" in the code and
"power" in the documentation rather than the appropriateness of either
"power-gpios" or "enable-gpios".

Mark.
