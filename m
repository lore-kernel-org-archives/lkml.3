Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaJCT5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:57:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39285 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaJCT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:57:26 -0400
Date: Fri, 3 Oct 2014 21:57:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        juha-matti.tilli@iki.fi
Subject: Re: [PATCH v5 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Message-ID: <20141003195723.GA6074@amd>
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
 <1408616242-21009-4-git-send-email-mperttunen@nvidia.com>
 <20140924183204.GE27076@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924183204.GE27076@developer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-09-24 14:32:06, Eduardo Valentin wrote:
> Hello Mikko,
> 
> On Thu, Aug 21, 2014 at 01:17:21PM +0300, Mikko Perttunen wrote:
> > This adds critical trip points to the Jetson TK1 device tree.
> > The device will do a controlled shutdown when either the CPU, GPU
> > or MEM thermal zone reaches 101 degrees Celsius.

> > +			trips {
> > +				trip@0 {
> > +					temperature = <101000>;
> > +					hysteresis = <0>;
> > +					type = "critical";
> > +				};

Would it be still time to switch to some more reasonable unit, like
degrees celsius? milicelsius is a bit of overkill.. ACPI uses
deciCelsius, but .. celsius should be enough.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
