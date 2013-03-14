Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3CNHOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:14:32 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33104 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab3CNHOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:14:31 -0400
Date: Thu, 14 Mar 2013 08:14:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] sched: Cputime update for 3.10
Message-ID: <20130314071427.GB7869@gmail.com>
References: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest cputime accounting updates that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	sched/core
> 
> HEAD: d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> 
> Some users are complaining that their threadgroup's runtime accounting 
> freezes after a week or so of intense cpu-bound workload. This set tries 
> to fix the issue by reducing the risk of multiplication overflow in the 
> cputime scaling code.

Hm, is this a new bug? When was it introduced and is upstream affected as 
well?

Thanks,

	Ingo
