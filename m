Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974AbaFTHxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:53:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:57259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaFTHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:53:20 -0400
Date: Fri, 20 Jun 2014 09:53:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [patch 2/2] clk: spear3xx: Set proper clock parent of uart1/2
In-Reply-To: <CAOh2x=niR4_jtWL2VRvZJ8LKkmW4fyNXB9+UzUKeRSagdm1xFw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406200952580.5170@nanos>
References: <20140619214858.755664030@linutronix.de> <20140619215140.348974921@linutronix.de> <CAOh2x=niR4_jtWL2VRvZJ8LKkmW4fyNXB9+UzUKeRSagdm1xFw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Viresh Kumar wrote:

> On Fri, Jun 20, 2014 at 3:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The uarts only work when the parent is ras_ahb_clk. The stale 3.5
> > based ST tree does this in the board file.
> >
> > Add it to the clk init function. Not pretty, but the mess there is
> > amazing anyway.
> 
> I still feel that board file is the right place to do it. Similar stuff might be
> required for some other peripheral clocks later and this solution
> wouldn't be scalable then.
> 
> But if you insist on doing it this way:

I really do not care much as long as it works.
 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
