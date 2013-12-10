Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3LJNgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:36:41 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50909 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3LJNgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:36:39 -0500
Date: Tue, 10 Dec 2013 14:36:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] clocksource/clockevents fixes for 3.13
Message-ID: <20131210133633.GB31366@gmail.com>
References: <52A0AC37.5010006@linaro.org>
 <20131210122051.GD30001@gmail.com>
 <52A71027.4000902@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A71027.4000902@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> On 12/10/2013 01:20 PM, Ingo Molnar wrote:
> >
> >* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >
> >>
> >>Hi Thomas,
> >>
> >>here are the fixes for 3.13 based on timers/urgent
> >
> >Please generally also post the patches to make it easier to review
> >them.
> 
> Hi Ingo,
> 
> what do you mean by "also post the patches" ? The patches were 
> posted in the mailing lists and I picked them up after people 
> reviewed them.

For example I found none of Dinh Nguyen's two patches on lkml.

Even if they were on lkml it's generally good practice to post patches 
for pull requests even if they are mostly resends of existing patches, 
especially for an urgent tree. That makes it easier for people to 
chime in on patches.

> Or shall I give a combined diff when sending the PR ?

Individual patches posted as a threaded reply to the pull request mail 
would be nice - those are easy for other people to ignore, yet they 
are informative to people who are interested in the series.

Thanks,

	Ingo
