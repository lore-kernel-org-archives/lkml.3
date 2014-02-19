Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaBSSxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:53:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43248 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754581AbaBSSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:53:24 -0500
Date: Wed, 19 Feb 2014 18:53:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v3] clk: return probe defer when DT clock not
	yet ready
Message-ID: <20140219185315.GV21483@n2100.arm.linux.org.uk>
References: <20140208132446.2A26694003E@smtp1-g21.free.fr> <20140219190305.788e537d@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
In-Reply-To: <20140219190305.788e537d@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 07:03:05PM +0100, Jean-Francois Moine wrote:
> On Mon, 25 Nov 2013 19:47:04 +0100
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
> > At probe time, a clock device may not be ready when some other device
> > wants to use it.
> > 
> > This patch lets the functions clk_get/devm_clk_get return a probe defer
> > when the clock is defined in the DT but not yet available.
> 
> Hi Mike,
> 
> Any news about this patch?

Mike,

Can you please have a look at this patch so that either you or I can take
this.  It /is/ required so that subsystems can correctly identify whether
a clock is missing because it's not specified in DT, or whether the clock
is missing because it's specified in DT but doesn't yet exist.

This patch has been hanging around for ages and deserves some attention.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
