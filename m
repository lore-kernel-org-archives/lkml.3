Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3FIHNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 03:13:23 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:53170 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3FIHNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 03:13:22 -0400
Date: Sun, 9 Jun 2013 07:13:21 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH 1/4] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
In-Reply-To: <1370526759-31163-2-git-send-email-bigeasy@linutronix.de>
Message-ID: <alpine.DEB.2.02.1306090713090.20050@utopia.booyaka.com>
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de> <1370526759-31163-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Sebastian Andrzej Siewior wrote:

> From: Philip Avinash <avinashphilip@ti.com>
> 
> EHRPWM module requires explicit clock gating of TBCLK from control
> module. Hence add TBCLK clock node in clock tree for EHRPWM modules.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> [bigeasy: remove CK_AM33XX]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks, queued.

- Paul
