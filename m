Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaA1TbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:31:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34903 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaA1TbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:31:08 -0500
Date: Tue, 28 Jan 2014 20:30:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, richard@nod.at, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86, um: Add generic barrier.h
Message-ID: <20140128193057.GG11314@laptop.programming.kicks-ass.net>
References: <tip-rcmiqb07nyuhtsnmanxlj3il@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-rcmiqb07nyuhtsnmanxlj3il@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:25:12AM -0800, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  673c36745c9f3100672853840b27e27638435e74
> Gitweb:     http://git.kernel.org/tip/673c36745c9f3100672853840b27e27638435e74
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Tue, 28 Jan 2014 15:12:36 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 28 Jan 2014 15:27:36 +0100
> 
> x86, um: Add generic barrier.h
> 
> It appears arch/um doesn't have any asm/barrier.h; cure this by
> including the generic one. Since UM is !SMP the defaults are good
> enough.
> 
> ( The motivation are the latest MCS locking patches which use generic
>   barriers. )
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>

I just talked to rw on IRC and he pointed out that commit 9af2452
(already in Linus' tree) does the same.
