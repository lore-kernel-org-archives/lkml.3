Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3JOHo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:44:58 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60457 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3JOHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:44:55 -0400
Date: Tue, 15 Oct 2013 09:44:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
Message-ID: <20131015074451.GA28186@gmail.com>
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
 <87txgj9eir.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txgj9eir.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> [SNIP]
> > +/* mmap file big chunks at a time */
> > +#define MMAP_OUTPUT_SIZE   (64*1024*1024)
> 
> Why did you choose 64MB for the size?  Did you also test other sizes?

Btw., should this value go up if the ring buffer (mmap_pages) is larger 
than 64MB?

Thanks,

	Ingo
