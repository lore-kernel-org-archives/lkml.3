Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbaGYPAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:00:39 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36112 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426AbaGYPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:00:11 -0400
Date: Fri, 25 Jul 2014 17:00:02 +0200
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
Message-ID: <20140725150002.GT4703@rric.localhost>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.14 21:58:36, Chen, Gong wrote:
> Back to long time ago (about 1.5 years), Thomas began the work
> for CPU hot-plug, one first thing is CPU hotplug flag cleanup.
> Paul hoped all the _FROZEN variants of the notifier actions
> can be removed at that time. Now here it is.
> 
> Patch 1 ~ 69: remove all kinds of XXX_FROZEN usages
> Patch 70: remove XXX_FROZEN from the kernel thoroughly

You might want to update Documentation/ as well.

-Robert
