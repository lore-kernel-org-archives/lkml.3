Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3KKUSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:18:00 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64470 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3KKURx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:17:53 -0500
Date: Mon, 11 Nov 2013 21:17:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        acme@ghostprotocols.net, hedi@sgi.com, sivanich@sgi.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/uv] x86/UV: Add uvtrace support
Message-ID: <20131111201750.GD17408@gmail.com>
References: <20130923212501.185052551@asylum.americas.sgi.com>
 <tip-8eba18428ac926f436064ac281e76d36d51bd631@git.kernel.org>
 <20131111185340.GA15854@gmail.com>
 <52812B50.7050503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52812B50.7050503@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> > Nothing actually uses the uv_trace() methods, plus nobody actually 
> > sets uv_trace_func.
> > 
> > Whatever hack this is, it has no place in the upstream kernel. I'll 
> > queue up a revert to make this pushable in this merge window.
>
> [...]
>
> Currently the uvtrace function is a separate module built out of tree.  
> It's pretty much prototype right now so not quite ready for general use.  
> It's used mostly to debug problems that are timing and/or load sensitive 
> as it's a very low overhead trace module that includes high resolution 
> timing.
> 
> Should I do this differently, perhaps with a register function?

Out of tree code essentially does not exist as far as the upstream kernel 
is concerned - especially if it causes crappy upstream code...

So either turn it into something clean and mergable, or patch your kernel 
and hide the uglies from others.

Thanks,

	Ingo
