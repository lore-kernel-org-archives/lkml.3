Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3JaFXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:23:17 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57839 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3JaFXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:23:14 -0400
Date: Thu, 31 Oct 2013 14:23:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] clocksource: sh_mtu2: Release clock when
 sh_mtu2_register() fails
Message-ID: <20131031052311.GK1603@verge.net.au>
References: <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1383057045-22608-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383057045-22608-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 03:30:44PM +0100, Laurent Pinchart wrote:
> Fix the probe error path to release the clock resource when the
> sh_mtu2_register() call fails.
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Thanks, I have queued this up.
