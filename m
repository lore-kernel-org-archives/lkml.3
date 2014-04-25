Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaDYEV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 00:21:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35848 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDYEVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 00:21:54 -0400
Message-ID: <5359E2C8.7030809@zytor.com>
Date: Thu, 24 Apr 2014 21:21:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Clean up and unify the vDSO
References: <cover.1398377016.git.luto@amacapital.net>
In-Reply-To: <cover.1398377016.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:08 PM, Andy Lutomirski wrote:
> This rewrites a bunch of the vdso code.  After these patches, the vvar
> and hpet pages are mapped directly after the vdso text on all five vdso
> variants.  The fixmaps are gone on 64-bit systems.
> 
> It would be possible to build the x32 vdso the normal way on top of
> these patches.
> 
> I haven't touched the pvclock code.  I'd want to understand why it
> exists, why it isn't using rdtsc, and why it has two rdtsc_barrier calls
> before rearranging it.  In a discussion with Marcello Tosatti, I think
> we concluded that the kvmclock code could be significantly simplified
> and sped up without breaking anything, but I want to save that for
> later.
> 
> This should apply to -linus or to tip/x86/vdso.  It's also here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=vdso/cleanups
> 
> and it has survived the build bot for a day.
> 

This doesn't apply cleanly on top of v3.15-rc2.  Could I ask you do
rebase it again?

	-hpa


