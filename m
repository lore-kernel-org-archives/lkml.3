Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaAQR3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:29:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45840 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAQR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:29:39 -0500
Message-ID: <52D9687F.6070506@wwwdotorg.org>
Date: Fri, 17 Jan 2014 10:29:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Add new scheduler syscalls to support
 an extended scheduling parameters ABI
References: <1383831828-15501-3-git-send-email-juri.lelli@gmail.com> <tip-d50dde5a10f305253cbc3855307f608f8a3c5f73@git.kernel.org>
In-Reply-To: <tip-d50dde5a10f305253cbc3855307f608f8a3c5f73@git.kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 08:53 AM, tip-bot for Dario Faggioli wrote:
> Commit-ID:  d50dde5a10f305253cbc3855307f608f8a3c5f73
> Gitweb:     http://git.kernel.org/tip/d50dde5a10f305253cbc3855307f608f8a3c5f73
> Author:     Dario Faggioli <raistlin@linux.it>
> AuthorDate: Thu, 7 Nov 2013 14:43:36 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 13 Jan 2014 13:41:04 +0100
> 
> sched: Add new scheduler syscalls to support an extended scheduling parameters ABI
> 
> Add the syscalls needed for supporting scheduling algorithms
> with extended scheduling parameters (e.g., SCHED_DEADLINE).

I'm seeing a regression in next-20140116 on my system, and "git bisect"
points at this patch. I noticed the fix patch "sched: Fix up scheduler
syscall LTP fails", but applying that doesn't solve the problem.

The symptoms are that when the system boots, I see the login prompt over
the serial port OK, but after I've entered my user/password, the login
process simply hangs. CTRL-C drops me back to the login prompt.

Do you have any hints how I should debug this?
