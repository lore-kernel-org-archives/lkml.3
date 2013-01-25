Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3AYVkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:40:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55517 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AYVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:40:08 -0500
Date: Fri, 25 Jan 2013 21:40:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/4 v11] arm: use device tree to get smp_twd clock
Message-ID: <20130125214000.GA23505@n2100.arm.linux.org.uk>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-2-git-send-email-mark.langsdorf@calxeda.com> <3041510.xugDHtFsGr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3041510.xugDHtFsGr@vostro.rjw.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:03:05PM +0100, Rafael J. Wysocki wrote:
> On Friday, January 25, 2013 01:46:42 PM Mark Langsdorf wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > Move clk setup to twd_local_timer_common_register and rely on
> > twd_timer_rate being 0 to force calibration if there is no clock.
> > Remove common_setup_called as it is no longer needed.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> 
> Russell, is this fine with you?

Looks fine to me, though I had to check twd_calibrate_rate() to make
sure it wouldn't run if the twd_timer_rate was non-zero.

If you want an acked-by:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
