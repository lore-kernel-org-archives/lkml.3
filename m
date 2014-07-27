Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaG0KR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 06:17:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54834 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaG0KRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 06:17:55 -0400
Date: Sun, 27 Jul 2014 12:17:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Robert Richter <rric@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, linux@arm.linux.org.uk,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, davem@davemloft.net,
        viro@zeniv.linux.org.uk, fweisbec@gmail.com, cl@linux.com,
        akpm@linux-foundation.org, axboe@kernel.dk, JBottomley@parallels.com,
        neilb@suse.de, christoffer.dall@linaro.org, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RESEND RFC PATCH v1 0/70] Gloabl CPU Hot-plug flag _FROZEN
 Clean up
Message-ID: <20140727101746.GA23752@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <20140725150002.GT4703@rric.localhost>
 <20140727063643.GA25432@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140727063643.GA25432@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 02:36:43AM -0400, Chen, Gong wrote:
> 1) This is RFC patch and I'm not sure if maintainers agree to remove
> XXX_FROZEN thoroughtly

I think so because this is part of a bigger rework of the whole stinking
CPU hotplug pile. And the frozen states are gone:

https://lkml.kernel.org/r/20130131120348.372374706@linutronix.de

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
