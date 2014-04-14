Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaDNCDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:03:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47903 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbaDNCDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 22:03:18 -0400
Date: Mon, 14 Apr 2014 11:03:15 +0900
From: Simon Horman <horms@verge.net.au>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: use PWM_LOOKUP to set the period and polarity
Message-ID: <20140414020315.GF22411@verge.net.au>
References: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1397066649-3767-3-git-send-email-alexandre.belloni@free-electrons.com>
 <20140409231549.GD2187@verge.net.au>
 <20140410073702.GF2879@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410073702.GF2879@piout.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:37:03AM +0200, Alexandre Belloni wrote:
> On 10/04/2014 at 08:15:49 +0900, Simon Horman wrote :
> > On Wed, Apr 09, 2014 at 08:04:09PM +0200, Alexandre Belloni wrote:
> > > Now that the PWM core is able to set the period and polarity based on
> > > the lookup table, add those to PWM_LOOKUP to ease their usage.
> > 
> > I would prefer if this change was made in a non-atomic manner.
> > 
> > 1. Add new infrastructure
> > 2. Update users individually
> > 3. Remove old infrastructure
> > 
> 
> I agree this would be better but I'm not sure how you can modify a macro
> without renaming it or changing it everywhere at once. Like said, I'm
> open to creating a new macro.

I for one would prefer the new macro approach.
