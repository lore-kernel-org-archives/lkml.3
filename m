Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3JGOLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:11:07 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:50039 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3JGOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:11:04 -0400
Date: Mon, 7 Oct 2013 16:11:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
Message-ID: <20131007141100.GA21873@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <5252BCB4.5030802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252BCB4.5030802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/7/13 5:55 AM, Ingo Molnar wrote:
>
> > This series improves various aspects of the tools/perf build system.
> 
> Branch in your tip tree? tip/rfc/perf does not seem to be it and you 
> have too many branches to manually search for it.

These changes are not yet committed into any stable Git tree - I've pushed 
them out into:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.perf

(it might take a few minutes for kernel.org to sync up.)

Thanks,

	Ingo
