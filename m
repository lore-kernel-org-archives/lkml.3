Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401AbaDJHhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:37:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965179AbaDJHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:37:05 -0400
Date: Thu, 10 Apr 2014 09:37:03 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Simon Horman <horms@verge.net.au>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: use PWM_LOOKUP to set the period and polarity
Message-ID: <20140410073702.GF2879@piout.net>
References: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1397066649-3767-3-git-send-email-alexandre.belloni@free-electrons.com>
 <20140409231549.GD2187@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409231549.GD2187@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2014 at 08:15:49 +0900, Simon Horman wrote :
> On Wed, Apr 09, 2014 at 08:04:09PM +0200, Alexandre Belloni wrote:
> > Now that the PWM core is able to set the period and polarity based on
> > the lookup table, add those to PWM_LOOKUP to ease their usage.
> 
> I would prefer if this change was made in a non-atomic manner.
> 
> 1. Add new infrastructure
> 2. Update users individually
> 3. Remove old infrastructure
> 

I agree this would be better but I'm not sure how you can modify a macro
without renaming it or changing it everywhere at once. Like said, I'm
open to creating a new macro.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
