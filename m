Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3KKLxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:53:15 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38395 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3KKLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:53:10 -0500
Date: Mon, 11 Nov 2013 12:53:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf record: mmap output file - v3
Message-ID: <20131111115307.GC19720@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
 <1383763297-27066-5-git-send-email-dsahern@gmail.com>
 <20131107080313.GB31926@gmail.com>
 <527BBA6E.2040609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527BBA6E.2040609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> >>+do_mmap:
> >>+		offset = rec->session->header.data_offset + rec->bytes_written;
> >>+		if (offset < (ssize_t) rec->mmap_out_size) {
> >>+			rec->mmap_offset = offset;
> >>+			offset = 0;
> >>+		} else
> >>+			rec->mmap_offset = 0;
> >
> >(Nit: unbalanced curly braces.)
> 
> I believe checkpatch.pl complains, but will add.

Hm, if that is so then please report that to the checkpatch folks, the 
warning is bogus and causes worse code to be written.

Thanks,

	Ingo
