Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3LDIk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:40:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53131 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3LDIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:40:24 -0500
Date: Wed, 4 Dec 2013 09:40:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/41] percpu: Consistent per cpu operations V1
Message-ID: <20131204084020.GB31737@gmail.com>
References: <20131203233232.928771708@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233232.928771708@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> The kernel has never been audited to ensure that this_cpu operations 
> are consistently used throughout the kernel. The code generated in 
> many places can be improved through the use of this_cpu operations 
> (which uses a segment register for relocation of per cpu offsets 
> instead of performing address calculations).

Your series lacks the this_cpu ops preempt debugging patches that you 
worked on before, what happened to them?

Those debug facilities caught kernel real bugs and they are thus 
essential before any percpu extension can be done.

Thanks,

	Ingo
