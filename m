Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3KSMIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:08:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3KSMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:08:22 -0500
Date: Tue, 19 Nov 2013 13:08:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119120813.GL3866@twins.programming.kicks-ass.net>
References: <20131112150751.GA19321@ghostprotocols.net>
 <20131112151944.GX5056@laptop.programming.kicks-ass.net>
 <52824AE3.4050207@gmail.com>
 <20131112211121.GC25913@gmail.com>
 <20131113113439.GI21461@twins.programming.kicks-ass.net>
 <52864ED1.1080607@gmail.com>
 <20131118090117.GE3866@twins.programming.kicks-ass.net>
 <20131118094036.GA26251@gmail.com>
 <877gc5utkf.fsf@sejong.aot.lge.com>
 <528AB229.6030603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AB229.6030603@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:34:49PM -0700, David Ahern wrote:
> I think Peter is asking about:
>     perf record -e faults -c 1 --call-graph dwarf,8192 -a -- sleep 1
> 
> And as expected it is a massive feedback spiraling out of control.

I was and good to know, thanks for testing.
