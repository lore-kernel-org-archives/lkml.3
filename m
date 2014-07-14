Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbaGNRi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbaGNRin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:38:43 -0400
Date: Mon, 14 Jul 2014 19:37:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, luto@amacapital.net,
        hpa@linux.intel.com
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Message-ID: <20140714173755.GH17761@krava.redhat.com>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714160947.GB9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 06:09:47PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 05:57:19PM +0200, Jiri Olsa wrote:
> > Following patch added another way to get mmap name:
> >   78d683e mm, fs: Add vm_ops->name as an alternative to arch_vma_name
> 
> Please add to your .gitconfig:
> 
> [core]
>         abbrev = 12

hum, will check

> 
> Also, you failed to CC the two people involved in that.

ouch.. sry

jirka
