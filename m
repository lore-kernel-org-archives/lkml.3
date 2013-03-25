Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab3CYUru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:47:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:51627 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3CYUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:47:49 -0400
Date: Mon, 25 Mar 2013 21:47:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
In-Reply-To: <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.02.1303252147080.22263@ionos>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-2-git-send-email-sboyd@codeaurora.org> <20130321180922.GB10716@e106331-lin.cambridge.arm.com> <514B4DBD.4060403@codeaurora.org> <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
 <5150800E.2000905@codeaurora.org> <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Mark Rutland wrote:
> Thomas, do you have an idea of if/when tip/timers/urgent will hit mainline?

Thanks for the reminder. I just sent a pull request Linuswards.

Thanks,

	tglx
