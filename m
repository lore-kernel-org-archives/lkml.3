Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaG1N2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:28:41 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60245 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaG1N2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:28:38 -0400
Date: Mon, 28 Jul 2014 15:28:21 +0200
From: Robert Richter <rric@kernel.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        bp@alien8.de, linux@arm.linux.org.uk, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, davem@davemloft.net, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, cl@linux.com, akpm@linux-foundation.org,
        axboe@kernel.dk, JBottomley@parallels.com, neilb@suse.de,
        christoffer.dall@linaro.org, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RESEND RFC PATCH v1 0/70] Gloabl CPU Hot-plug flag _FROZEN
 Clean up
Message-ID: <20140728132821.GV4703@rric.localhost>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <20140725150002.GT4703@rric.localhost>
 <20140727063643.GA25432@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140727063643.GA25432@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.07.14 02:36:43, Chen, Gong wrote:
> On Fri, Jul 25, 2014 at 05:00:02PM +0200, Robert Richter wrote:
> > > Back to long time ago (about 1.5 years), Thomas began the work
> > > for CPU hot-plug, one first thing is CPU hotplug flag cleanup.
> > > Paul hoped all the _FROZEN variants of the notifier actions
> > > can be removed at that time. Now here it is.
> > > 
> > > Patch 1 ~ 69: remove all kinds of XXX_FROZEN usages
> > > Patch 70: remove XXX_FROZEN from the kernel thoroughly
> > 
> > You might want to update Documentation/ as well.
> > 
> Thanks for your reminder. I don't do that intentionally because
> 1) This is RFC patch and I'm not sure if maintainers agree
> to remove XXX_FROZEN thoroughtly
> 2) I have a little bit hesitation how to describe XXX_FROZEN
> status after they are removed.
> 
> Anyway, I will do that in formal patch series. Thanks again!

Yes, thanks. It does not make sense to remove the XXX_FROZEN pattern
in the code while keeping it in the cpu hotplug description.

-Robert
