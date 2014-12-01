Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaLAKmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:42:01 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41719 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaLAKmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:42:00 -0500
Date: Mon, 1 Dec 2014 10:41:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
Message-ID: <20141201104145.GY3836@n2100.arm.linux.org.uk>
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:55:40PM +0000, Liviu Dudau wrote:
> +	/*
> +	 * PPIs are optionally configurable, but we cannot distinguish
> +	 * between high and low, nor falling and rising. Change the
> +	 * type so that it passes the next check.

This comment could do with a /lot/ of improvement.  It sounds like the
only reason this code exists is to bypass the check.  If that's all
that's being done, there's better ways to code it.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
