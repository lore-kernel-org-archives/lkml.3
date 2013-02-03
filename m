Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3BCLFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:05:44 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58219 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3BCLFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:05:42 -0500
Date: Sun, 3 Feb 2013 12:05:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] perf: integrate liblockdep support into perf
Message-ID: <20130203110537.GB11739@gmail.com>
References: <1359738953-28745-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359738953-28745-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> liblockdep is simply userspace lockdep. We can use that to analyze and
> verify the locking in perf.
> 
> Usage is simple, to compile perf with liblockdep all that's needed it:
> 
> 	make LIBLOCK=[path to liblockdep]

Nice idea.

I'd suggest to link it in directly, like we link in 
libtraceevents.

Then it could be built via something like:

   make LOCKDEP=1

or so.

Thanks,

	Ingo
