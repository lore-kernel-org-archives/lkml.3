Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3KKO6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:58:22 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59149 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3KKO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:58:12 -0500
Date: Mon, 11 Nov 2013 11:58:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
Message-ID: <20131111145804.GB27198@ghostprotocols.net>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
 <1383884605-30968-3-git-send-email-dsahern@gmail.com>
 <20131111112906.GE15810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111112906.GE15810@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 11, 2013 at 12:29:06PM +0100, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:

> > shows a drop in time, CPU cycles, and instructions all drop by more than a
> > factor of 3. Jiri also ran a test that showed a big improvement.
> > 
> > v4: Refactoring per Ingo's comments
> > 
> > v3: Removed use of bytes_at_mmap_start at the stat() that set it
> >     Added user option to control the size of the mmap for writing file.
> > 
> > v2: Removed msync call before munmap per Jiri's suggestion

> Looks very clean now!
 
> Acked-by: Ingo Molnar <mingo@kernel.org>

Applied the prep patch, but waiting for v5 as stated by David when
answering Jiri's concerns.

- Arnaldo
