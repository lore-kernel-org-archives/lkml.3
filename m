Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaJBPdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbaJBPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:33:38 -0400
Date: Thu, 2 Oct 2014 17:33:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
Message-ID: <20141002153307.GL9764@krava.brq.redhat.com>
References: <1412245929-27579-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1412245929-27579-2-git-send-email-yarygin@linux.vnet.ibm.com>
 <20141002141559.GJ9764@krava.brq.redhat.com>
 <87tx3m7azt.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx3m7azt.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 07:21:58PM +0400, Alexander Yarygin wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> [..]
> 
> >
> > looks ok.. but I was wondering if we could move those repeating
> > bits in function.. something like below (untested, just compiled)
> >
> > thanks,
> > jirka
> >
> >
> 
> [..]
> 
> Yep, it's better. Just checked - it works. How should we process?

just update your patch with that change and resend

thanks,
jirka
