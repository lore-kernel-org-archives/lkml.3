Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3J2F4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:56:04 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60633 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3J2F4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:56:01 -0400
Date: Tue, 29 Oct 2013 14:55:58 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] clocksource: sh_tmu: Add clk_prepare/unprepare
 support
Message-ID: <20131029055558.GD11580@verge.net.au>
References: <1383000569-8916-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:49:20PM +0100, Laurent Pinchart wrote:
> Prepare the clock at probe time, as there is no other appropriate place
> in the driver where we're allowed to sleep.
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/clocksource/sh_tmu.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

Thanks Laurent,

I have queued this up in the clocksources branch of my renesas tree.
I will send a pull request to Mike once v3.13-rc1 has hit the shelves.
Mike, please let me know if you would prefer something earlier than that.
