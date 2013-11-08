Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3KHFWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:22:30 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44168 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3KHFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:22:25 -0500
Date: Fri, 8 Nov 2013 14:22:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] clocksource: sh_tmu: Add clk_prepare/unprepare
 support
Message-ID: <20131108052222.GA9828@verge.net.au>
References: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1383057097-22689-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1383057097-22689-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20131031052406.GN1603@verge.net.au>
 <527B9861.1020606@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527B9861.1020606@linaro.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 02:40:49PM +0100, Daniel Lezcano wrote:
> On 10/31/2013 06:24 AM, Simon Horman wrote:
> >On Tue, Oct 29, 2013 at 03:31:37PM +0100, Laurent Pinchart wrote:
> >>Prepare the clock at probe time, as there is no other appropriate place
> >>in the driver where we're allowed to sleep.
> >>
> >>Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>Cc: linux-kernel@vger.kernel.org
> >>Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >
> >Thanks, I have queued this up.
> 
> Ok, so those patches go through your tree, right ?
> 
> I have been out for the Linaro connect but I saw you picked them. In
> the future, I would prefer to take them in my tree as they fall
> under the drivers/clocksource maintainer's umbrella.

I was planning to send a pull request to you.
But if you would rather just pick them up directly that is quite fine by me.

Acked-by: Simon Horman <horms+renesas@verge.net.au>
