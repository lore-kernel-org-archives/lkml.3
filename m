Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3B0Kr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:47:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51112 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3B0KrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:47:25 -0500
Date: Wed, 27 Feb 2013 10:47:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        tglx@linutronix.de, viresh.kumar@linaro.org,
        jacob.jun.pan@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 0/4] time: dynamic irq affinity
Message-ID: <20130227104701.GZ17833@n2100.arm.linux.org.uk>
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <512DA0EB.5000803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512DA0EB.5000803@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:30:11AM +0530, Santosh Shilimkar wrote:
> P.S: Time and again it proves that making the local timer wakeup
> capable solves the issue.

Slightly different take: it proves that hardware people don't talk to
software people about what they require to make an operating system
work.  Hardware people think they understand that and go off and do
their own thing, and expect software people to sort out their mess.

This happens all the time; there is no solution for it as long as
companies view the creation of hardware as being entirely separate
from software.
