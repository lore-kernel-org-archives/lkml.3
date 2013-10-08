Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3JHICX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:02:23 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34114 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3JHICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:02:16 -0400
Date: Tue, 8 Oct 2013 10:02:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <paul.mundt@gmail.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] sched: Remove ARCH specific fpu_counter from
 task_struct
Message-ID: <20131008080212.GA6541@gmail.com>
References: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
 <1381218389-16585-4-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381218389-16585-4-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> 
> fpu_counter in task_struct was used only by sh/x86.
> Both of these now carry it in ARCH specific thread_struct, hence this
> can now be removed from generic task_struct, shrinking it slightly for
> other arches.
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
