Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3FKRLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:11:05 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36271 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3FKRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:10:57 -0400
Date: Tue, 11 Jun 2013 18:10:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 10/22] mfd/ti_am335x_tscadc: Add DT support
Message-ID: <20130611171051.GA4320@laptop>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-11-git-send-email-bigeasy@linutronix.de>
 <20130611142347.GF29135@zurbaran>
 <51B73756.5010004@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51B73756.5010004@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >> Signed-off-by: Patil, Rachna <rachna@ti.com>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> [bigeasy: module alias, rename to ti,am3359-tscadc as it was tested on
> >>           AM3359]
> > I honestly can't tell if this is a change from the last version of your
> > patchset or a description of this patch changes in general.
> > This is cluttering your commit logs, please remove this as well.
> 
> I took the original patch. Every change I made to it because people
> asked to merge changes into the patch where the problem occurred I
> added it here before my sign-off.
> 
> In the end I would like not to post a patch with "From: != me" and
> don't make change which the original author did not do. Also dropping
> their authorship isn't nice. What could we agree on?

Generally speaking, if it is necessary to merge various author's
patches into one, then you can the merger will tend to take authorship
of the commit. Note that just because you are the author of the
commit, it doesn't mean you authored the patch.

I also use the rule of thumb that if you make significant changes to a
patch, then you can also assume authorship too. I'll leave the 'how
much is significant' to your own good judgement.

If you're just making a few fixups, then just add your SOB in the
normal way. That should be enough reward for a mere few patch fixes.

Adding little 'I-did-this' notes to the commit log should mostly be
avoided IMO.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
