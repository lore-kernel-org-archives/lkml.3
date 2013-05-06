Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3EFRpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab3EFRpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:45:40 -0400
Date: Mon, 6 May 2013 19:44:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFCv2 0/8] perf tools: Adding formula support
Message-ID: <20130506174459.GA4562@krava.brq.redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:15:38PM +0200, Jiri Olsa wrote:
> hi,
> adding support to define counters for stat command,
> by using user defined events and counters.
> 
> Initial RFC is here:
> http://marc.info/?l=linux-kernel&m=135825930106535&w=2
> 
> v2 main changes:
>   - counter formula grammar changed
>     (details in patch 4 changelog)
>   - using -e 'formula-<name>' way of using configured <name> set
>     for stat command
>     (details in patch 7 changelog)

forgot.. changes could be reached in here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/formula3

jirka
