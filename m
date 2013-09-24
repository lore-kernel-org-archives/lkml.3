Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3IXJtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:49:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab3IXJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:49:39 -0400
Date: Tue, 24 Sep 2013 10:49:37 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: arizona: Add device tree helper functions
Message-ID: <20130924094937.GN3635@opensource.wolfsonmicro.com>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5240B464.2010903@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240B464.2010903@wwwdotorg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 03:36:36PM -0600, Stephen Warren wrote:
> On 09/23/2013 12:30 PM, Charles Keepax wrote:
> > -  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
> > +  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
> 
> That looks like an incompatible change to the DT ABI.

The supply name in the driver is AVDD as is the name for the pin
on the datasheet, if you specify it as AVDD1 in device tree the
current driver will not load.

This appears to have been a copy and paste error from the wm8994
which has 2 AVDD supplies and I believe these docs were based
on. I would prefer to update the documentation to match what the
driver already expects rather than the other way around.

Thanks,
Charles
