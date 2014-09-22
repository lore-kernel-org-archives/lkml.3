Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaIVPHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:07:31 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37374 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754255AbaIVPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:27 -0400
Date: Mon, 22 Sep 2014 16:06:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 00/10] Per-user clock constraints
Message-ID: <20140922150658.GM5182@n2100.arm.linux.org.uk>
References: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:12:02PM +0200, Tomeu Vizoso wrote:
> Hello,
> 
> my branch was finally processed by the 0day build farm and I have fixed the
> three issues that came up:

Patch 3 did not come through, so I can't see the changes there.  I'm
assuming that there's some changes to clkdev in there which I need to
see.

> * export __clk_get and __clk_put, so they can be used by clock implementations
> in modules that previously used clk_get and clk_put.

This is something I'm not happy about.  We don't want people getting
access to these low level functions.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
