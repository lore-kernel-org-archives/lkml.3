Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3KEGZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:25:42 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48596 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3KEGZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:25:41 -0500
Date: Tue, 5 Nov 2013 07:25:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>, Josh Boyer <jwboyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131105062537.GA31880@gmail.com>
References: <20131103155729.GB9944@hansolo.jdub.homelinux.org>
 <20131104065343.GC13030@gmail.com>
 <20131104140141.GC9944@hansolo.jdub.homelinux.org>
 <20131104141051.GA19355@gmail.com>
 <20131104141615.GD9944@hansolo.jdub.homelinux.org>
 <20131104155624.GA31656@sgi.com>
 <20131104174841.GA19498@gmail.com>
 <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com>
 <20131104201111.GA19789@gmail.com>
 <527824C3.6000504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527824C3.6000504@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/04/2013 12:11 PM, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> >> 8192 maybe?
> > 
> > Yeah, that makes more sense I guess.
> > 
> 
> However, I still have serious issues with crap like this because 
> randconfig is basically broken.  If nothing else we need to get that 
> feedback to the kconfig maintainers.

The problem with that is that there are no kconfig maintainers:

  KCONFIG
  ...
  S:      Odd Fixes

The kconfig code is still a hard to maintain, scarcely documented mess. It 
took us almost a decade to rescue the NTP code from a similar obfuscation 
trap and make it maintainable. It had the same author as the original 
Kconfig code - and the Kconfig code is 10 times larger than the NTP code.

Thanks,

	Ingo
