Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3FZP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:58:41 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36064 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FZP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:58:40 -0400
Date: Wed, 26 Jun 2013 17:58:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130626155835.GC7399@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
 <20130623092840.GB13445@gmail.com>
 <20130624203657.GA107621@asylum.americas.sgi.com>
 <20130626121430.GA4980@gmail.com>
 <20130626144903.GA2210@asylum.americas.sgi.com>
 <51CB04C7.8060702@intel.com>
 <51CB06BD.8090202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB06BD.8090202@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Zimmer <nzimmer@sgi.com> wrote:

> On 06/26/2013 10:12 AM, Dave Hansen wrote:
> >On 06/26/2013 07:49 AM, Nathan Zimmer wrote:
> >>My guess it is the NMIs overwhelming the system but I have not found a good way
> >>to profile perf gone wild so it is only a guess.
> >I've got an 80-core system and the symptoms sound similar to perf issues
> >I'm seeing.  Dropping the sample rate helped for me, and there's a patch
> >in -tip at the moment to do it automatically:
> >
> >>http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=14c63f17b1fde5a575a28e96547a22b451c71fb5
> >Looks like you've also found that debugging NMIs is fun. :)
> More fun then one person can handle.
> I'll have to take this patch for a spin.

Please try latest -tip:master, there's a series of patches from Dave that 
address this problem category.

Does it only happen with -g, or with regular perf record and/or with perf 
top as well?

Thanks,

	Ingo
