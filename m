Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3FMNPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:15:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:49039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3FMNPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:15:38 -0400
Date: Thu, 13 Jun 2013 15:15:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over global
 devices
In-Reply-To: <51B991EF.70800@linaro.org>
Message-ID: <alpine.LFD.2.02.1306131331430.22970@ionos>
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org> <1370291642-13259-2-git-send-email-sboyd@codeaurora.org> <51B0A6E8.20909@linaro.org> <20130606180425.GQ599@codeaurora.org> <51B10D85.1060507@linaro.org> <20130606223848.GR599@codeaurora.org>
 <20130612214435.GE10823@codeaurora.org> <51B991EF.70800@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Daniel Lezcano wrote:
> I prefer Thomas to have a look at it and ack it. I changed Cc to To for
> Thomas.

The patch does not apply on tip timers/core. The code has been
reworked a month ago. Please work against tip timers/core. That's
where this stuff ends up.

Thanks,

	tglx
