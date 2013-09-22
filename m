Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3IVNHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 09:07:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39779 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IVNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 09:07:48 -0400
Date: Sun, 22 Sep 2013 14:00:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
	support for Allwinner A20(sunxi 7i).
Message-ID: <20130922130056.GQ12758@n2100.arm.linux.org.uk>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com> <1379852488-32147-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379852488-32147-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 08:21:26PM +0800, Fan Rong wrote:
> +.section ".text.head", "ax" ENTRY(sun7i_secondary_startup)
> +msr cpsr_fsxc,
> +#0xd3
> +b secondary_startup ENDPROC(sun7i_secondary_startup)

This looks like it's been messed up somehow.

