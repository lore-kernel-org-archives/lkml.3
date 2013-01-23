Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3AWLNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:13:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab3AWLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:13:05 -0500
Date: Wed, 23 Jan 2013 12:12:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: x86: report_lost_ticks doesn't exist any more
In-Reply-To: <alpine.LNX.2.00.1301171118260.14768@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1301231212420.20374@pobox.suse.cz>
References: <alpine.LNX.2.00.1301171118260.14768@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Jiri Kosina wrote:

> 'report_lost_ticks' parameter has been removed back in 2007 through 
> 1489939f0ab ("time: x86_64: convert x86_64 to use GENERIC_TIME").
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  Documentation/x86/x86_64/boot-options.txt |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> index de38429..e015a83 100644
> --- a/Documentation/x86/x86_64/boot-options.txt
> +++ b/Documentation/x86/x86_64/boot-options.txt
> @@ -112,10 +112,6 @@ Timing
>    This can be used to work around timing problems on multiprocessor systems
>    with not properly synchronized CPUs.
>  
> -  report_lost_ticks
> -  Report when timer interrupts are lost because some code turned off
> -  interrupts for too long.
> -
>    nohpet
>    Don't use the HPET timer.

Noone seems to have picked this up, I am taking it through trivial.git

-- 
Jiri Kosina
SUSE Labs
