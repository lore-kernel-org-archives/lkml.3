Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3C0RJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:09:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:36683 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3C0RJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:09:19 -0400
Date: Wed, 27 Mar 2013 18:09:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
In-Reply-To: <20130327164716.4014.97638@quantum>
Message-ID: <alpine.LFD.2.02.1303271807040.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1303271209490.22263@ionos> <20130327164716.4014.97638@quantum>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Mike Turquette wrote:
> Thanks for the review Thomas.  I will steal your code and call it my own
> in the next version.

Sure.

> In particular getting rid of the atomics makes things much nicer.

I'd say using the helper functions and not having all these
conditionals makes it really nice :)

Thanks,

	tglx
