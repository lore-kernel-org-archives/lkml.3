Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaJFHZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:25:05 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13739 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJFHZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:25:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 06 Oct 2014 00:24:51 -0700
Date: Mon, 6 Oct 2014 10:24:57 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Eduardo Valentin <edubezval@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>, <rui.zhang@intel.com>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <juha-matti.tilli@iki.fi>
Subject: Re: [PATCH v5 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Message-ID: <20141006072457.GM9139@tbergstrom-lnx.Nvidia.com>
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com>
 <1408616242-21009-4-git-send-email-mperttunen@nvidia.com>
 <20140924183204.GE27076@developer> <20141003195723.GA6074@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141003195723.GA6074@amd>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 09:57:24PM +0200, Pavel Machek wrote:
> On Wed 2014-09-24 14:32:06, Eduardo Valentin wrote:
> > Hello Mikko,
> > 
> > On Thu, Aug 21, 2014 at 01:17:21PM +0300, Mikko Perttunen wrote:
> > > This adds critical trip points to the Jetson TK1 device tree.
> > > The device will do a controlled shutdown when either the CPU, GPU
> > > or MEM thermal zone reaches 101 degrees Celsius.
> 
> > > +			trips {
> > > +				trip@0 {
> > > +					temperature = <101000>;
> > > +					hysteresis = <0>;
> > > +					type = "critical";
> > > +				};
> 
> Would it be still time to switch to some more reasonable unit, like
> degrees celsius? milicelsius is a bit of overkill.. ACPI uses
> deciCelsius, but .. celsius should be enough.
> 

We should be using deciKelvin then.

Cheers,

Peter.
