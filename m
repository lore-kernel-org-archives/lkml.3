Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3JOLEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:04:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3JOLEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:04:22 -0400
Date: Tue, 15 Oct 2013 13:04:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf tools: use ansi versions of asm and volatile
Message-ID: <20131015110409.GG10651@twins.programming.kicks-ass.net>
References: <1381833986-19393-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381833986-19393-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 04:16:26PM +0530, Ramkumar Ramachandra wrote:
> asm and volatile are provided for backward compatibility; use the ansi
> versions __asm__ and __volatile__.
> 

I won't object much to this; but I have to note that the entire kernel
tree is loaded with the non-ansi variant and thus we're fairly certain
it will continue working :-)
