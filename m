Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab3JOLQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:16:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3JOLQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:16:03 -0400
Date: Tue, 15 Oct 2013 13:15:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf tools: use ansi versions of asm and volatile
Message-ID: <20131015111551.GH10651@twins.programming.kicks-ass.net>
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

Also, you seem to have 'forgotten' to convert the 31 other instances :-)

# git grep -E "[[:space:]]asm[([:space:]]" tools/perf/ | wc -l
32
