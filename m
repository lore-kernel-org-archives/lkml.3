Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaBVK0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:26:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46777 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751350AbaBVK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:26:23 -0500
Date: Sat, 22 Feb 2014 10:26:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Russ Dill <Russ.Dill@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH RFC v1 1/3] ARM: Add irq disabled version of
	soft_restart.
Message-ID: <20140222102616.GG21483@n2100.arm.linux.org.uk>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392774729-3235-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:52:07PM -0800, Sebastian Capella wrote:
> From: Russ Dill <Russ.Dill@ti.com>
> 
> This adds the ability to run soft_restart with local_irq/fiq_disable
> already called. This is helpful for the hibernation code paths.

I'd rather keep this simple.  There's no problem with calling soft_restart
with interrupts already disabled.  local_irq_disable()/local_fiq_disable()
there should be harmless.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
