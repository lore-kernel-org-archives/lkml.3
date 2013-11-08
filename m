Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3KHR7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:59:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3KHR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:59:24 -0500
Date: Fri, 8 Nov 2013 18:58:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing the
 perf data file
Message-ID: <20131108175851.GB8444@krava.brq.redhat.com>
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 09:41:46AM -0700, David Ahern wrote:
> If perf fails to write data to the data file (e.g., ENOSPC error) it fails
> with the message:
>   failed to write perf data, error: No space left on device
> 
> and stops — killing the workload too. The file is an unknown state. Trying
> to read it (e.g., perf report) fails with a SIGBUS error.
> 
> Fix by deleting the file on a failure.

I think that's right thing to do

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
