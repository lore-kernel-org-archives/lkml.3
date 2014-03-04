Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaCDWYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:24:07 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:65148 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaCDWYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:24:03 -0500
Date: Tue, 4 Mar 2014 14:23:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
Message-ID: <20140304222357.GA6125@roeck-us.net>
References: <1393932664-13319-1-git-send-email-wni@nvidia.com>
 <1393932664-13319-4-git-send-email-wni@nvidia.com>
 <53164E78.5010708@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53164E78.5010708@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 03:06:48PM -0700, Stephen Warren wrote:
> On 03/04/2014 04:31 AM, Wei Ni wrote:
> > Add dt node to describe the thermal zone for the nct1008.
> > 
> > Change-Id: I0256836e52d73ec282574e4fd91df52958936e35
> 
> ???????
> 
I think this is for one of those open-source sites out there
which count open source contributions. Not Ohloh, but similar.
You have to specify that Change-Id to have it associate your
name with the patch.

Guenter

> > diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> 
> > +	thermal-zones {
> > +		nct1008-local {
> > +			polling-delay-passive = <2000>; /* milliseconds */
> 
> Nothing can possible make use of this node, since there's no compatible
> value or anything else like that to bind a driver to it.
> 
