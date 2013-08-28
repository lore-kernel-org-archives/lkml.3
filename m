Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3H1J3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:29:48 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33567 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3H1J3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:29:47 -0400
Date: Wed, 28 Aug 2013 11:29:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org
Subject: Re: Improve preempt-scheduling and x86 user access v3
Message-ID: <20130828092943.GA14094@gmail.com>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Various optimizations related to CONFIG_PREEMPT_VOLUNTARY and x86 
> uaccess

Looks mostly good.

Does this patchset change the number of cond_resched() preemption points 
on CONFIG_PREEMPT_VOLUNTARY=y, or is it a scheduling invariant?

Thanks,

	Ingo
