Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3GXSjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:39:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44892 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3GXSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:39:13 -0400
Date: Wed, 24 Jul 2013 11:39:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v5 0/5] clk: implement remuxing during set_rate
Message-ID: <20130724183912.GC27761@codeaurora.org>
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
 <20130621170407.20448.35605@quantum>
 <CAAG0J9-F0P67=oaE5UHhmgd3Wz4k4XjsRjWShxmKOqicAyrhfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAG0J9-F0P67=oaE5UHhmgd3Wz4k4XjsRjWShxmKOqicAyrhfw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, James Hogan wrote:
> On 21 June 2013 18:04, Mike Turquette <mturquette@linaro.org> wrote:
> > Quoting James Hogan (2013-06-13 09:05:57)
> >> This patchset adds support for automatic selection of the best parent
> >> for a clock mux, i.e. the one which can provide the closest clock rate
> >> to that requested. It can be disabled by a new CLK_SET_RATE_NO_REPARENT
> >> flag (which is set for all uses of clk_register_mux().
> >>
> >> This works by way of adding a new op, determine_rate, similar to
> >> round_rate but with an extra parameter to allow the clock driver to
> >> optionally select a different parent clock. This is used in
> >> clk_calc_new_rates to decide whether to initiate a set_parent operation.
> >
> > Hi James,
> >
> > I'm going to hold off on this one for 3.11. I'll revisit it after the
> > next merge window.
> 
> Okay, no worries.
> 

Has a new patchset been sent out? I'd like to see this merge in
3.12.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
