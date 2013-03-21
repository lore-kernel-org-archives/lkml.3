Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3CUUNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:13:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41210 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3CUUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:13:32 -0400
Date: Thu, 21 Mar 2013 19:36:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        pawel.moll@arm.com, linus.walleij@linaro.org,
        Rob Herring <rob.herring@calxeda.com>, john.stultz@linaro.org,
        haojian.zhuang@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH 11/11] devtree: add binding documentation for sp804
Message-ID: <20130321193635.GT4977@n2100.arm.linux.org.uk>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com> <1363820051-24428-12-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363820051-24428-12-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 05:54:11PM -0500, Rob Herring wrote:
> +Optional properties:
> +- arm,sp804-has-irq = <#>: In the case of only 1 timer irq line connected, this
> +	specifies if the irq connection is for timer 1 or timer 2. A value of 1
> +	or 2 should be used.

This fails to mention that it has any bearing on the clocks.
