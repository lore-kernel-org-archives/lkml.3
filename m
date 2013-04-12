Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3DLFcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:32:39 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:57547 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3DLFci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:32:38 -0400
Date: Fri, 12 Apr 2013 07:32:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130412053234.GB3887@gmail.com>
References: <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411202328.GA15955@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Apr 11, 2013 at 12:26:09PM -0700, H. Peter Anvin wrote:
> > What host is this?
> 
> Judging by the DMI string in the oops:
> 
> > [   15.921486] Pid: 73, comm: hwclock Tainted: G        W    3.9.0-rc6+ #222032 System manufacturer System Product Name/A8N-E
> 
> it is an ASUS board with a K8 on it - probably Ingo's old K8 which
> triggers all kinds of crap off an on.
> 
> 8-)

Yep, with Fedora Core 8, and totally unchanged userspace, booting randconfigs of 
the latest -tip:master tree. This box has booted up over a million Linux kernels 
in the past 4+ years, so when it shows new types of sickness then in 99.9% of the 
cases it's something about the kernel.

The lockup went away after excluding x86/cpu. I'll try more testing as time 
permits.

Thanks,

	Ingo
