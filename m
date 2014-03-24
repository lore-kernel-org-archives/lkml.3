Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaCXIhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:37:36 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57885 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaCXIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:37:35 -0400
Date: Mon, 24 Mar 2014 08:37:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, joshc@codeaurora.org
Subject: Re: [PATCH] regulator: Add new driver for ST's PWM controlled
 voltage regulators
Message-ID: <20140324083719.GJ8541@lee--X1>
References: <1395397296-8196-1-git-send-email-lee.jones@linaro.org>
 <20140321182039.GQ552@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140321182039.GQ552@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On some STMicroelectronics hardware reside regulators consisting
> > partly of a PWM input connected to the feedback loop. As the PWM
> > duty-cycle is varied the output voltage adapts. This driver
> > allows us to vary the output voltage by adapting the PWM input
> > duty-cycle.
> 
> Applied, thanks.  Please send incremental fixes for the things Josh
> mentioned.

Looks like Axel was bored.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
