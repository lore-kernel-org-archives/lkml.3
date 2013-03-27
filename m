Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3C0RM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:12:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:36723 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3C0RMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:12:25 -0400
Date: Wed, 27 Mar 2013 18:12:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
In-Reply-To: <20130327150634.4014.64797@quantum>
Message-ID: <alpine.LFD.2.02.1303271811020.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <1824016.8AdaQMMrrR@avalon> <20130327150634.4014.64797@quantum>
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
> Quoting Laurent Pinchart (2013-03-27 02:08:15)
> > I wonder if it would make sense to abstract these operations in a generic 
> > recursive mutex. Given that it would delay this patch past v3.10 I won't push 
> > for that.
> > 
> 
> Having a nice implementation of recursive mutexes would have saved me
> some time.

If you encapsulate stuff nicely like I suggested, then switching to a
generic version later on is a nobrainer.
 
Thanks,

	tglx
