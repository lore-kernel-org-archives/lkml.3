Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3IENim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:38:42 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45521 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3IENik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:38:40 -0400
Date: Thu, 5 Sep 2013 15:38:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.12
Message-ID: <20130905133836.GA26634@gmail.com>
References: <20130903132933.GA24955@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903132933.GA24955@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

>    * 'perf report/top' enhancements:
> 
>         . Do annotation using /proc/kcore and /proc/kallsyms when 
>           available, removing the forced need for a vmlinux file kernel 
>           assembly annotation. This also improves this use case because 
>           vmlinux has just the initial kernel image, not what is actually 
>           in use after various code patchings by things like alternatives.
>           By Adrian Hunter.

Btw., this new feature is most noticeable if you run 'perf top' as root on 
any random box: you can annotate based on the live kernel image straight 
away, without having the vmlinux.

This works on various distro kernels as well.

Thanks,

	Ingo
