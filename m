Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaKEOyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbaKEOyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:00 -0500
Date: Wed, 5 Nov 2014 09:53:56 -0500
From: Don Zickus <dzickus@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: uobergfe@redhat.com, drjones@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20141105145356.GL135937@redhat.com>
References: <20141105093420.1c7500d8@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105093420.1c7500d8@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:34:20AM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> commit 9919e39a1738 ("kvm: ensure hard lockup detection is disabled by
> default") provided a way for the kernel to disable the hard lockup
> detector at runtime.
> 
> I'm using it on ppc64 but notice some weird behaviour with the
> nmi_watchdog procfs variable. At boot, that the hard lockup
> detector appears to be enabled even when we disable it via
> watchdog_enable_hardlockup_detector(false):
> 
> # cat /proc/sys/kernel/nmi_watchdog 
> 1
> 
> I have to echo 0 to it then echo 1 again to enable it.

Hi Anton,

I believe Andrew answered the question for you, it's a WIP and we have
patches to clean that up.

I don't see ppc64 watchdog support in arch/powerpc, is that something you
are working with on implementing?

Cheers,
Don
