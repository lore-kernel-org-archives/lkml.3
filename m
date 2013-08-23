Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3HWUgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:36:19 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:41246 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3HWUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:36:17 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] max77693: added device tree support
Date: Fri, 23 Aug 2013 22:36:10 +0200
Message-ID: <2068495.b8bxEK36PI@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <20130823141433.GI25856@e106331-lin.cambridge.arm.com>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com> <1377104014-21910-3-git-send-email-a.hajda@samsung.com> <20130823141433.GI25856@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Friday 23 of August 2013 15:14:33 Mark Rutland wrote:
> On Wed, Aug 21, 2013 at 05:53:34PM +0100, Andrzej Hajda wrote:
> > This patch adds only of_match_table.
> > There are no device specific properties.
> 
> Could you clarify what functionality this enables and what it doesn't,
> please?

This patch simply adds explicit OF match table for this device. Before, 
the driver could be matched only by a fallback to i2c_device_id table.

> This doesn't seem to enable support for the regulators described in the
> binding [1] (which from the looks of it needs proof-reading and possibly
> rework).
> 
> Are there any changes we might need in future to either support new
> functionality or to generalise the binding. e.g. do we need a regulator
> for the LED?
> 
> Given the binding has never been supported, are we happy now that it
> best represents the hardware, or are there avenues of improvement
> *before* it becomes ABI?

Well, documentation of the binding has been present in kernel tree since 
June, but I too think that we should review it and make sure it makes 
sense. I'll try to get some information on this chip at work, on Monday.

Best regards,
Tomasz

