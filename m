Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaFDMIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaFDMId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:08:33 -0400
Date: Wed, 4 Jun 2014 14:08:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: Fw: Re: [PATCH 1/1] powerpc/perf: Adjust callchain based on
 DWARF debug info
Message-ID: <20140604120801.GE5555@krava.brq.redhat.com>
References: <20140530155925.GF7427@krava.brq.redhat.com>
 <20140602141219.GB7861@krava.brq.redhat.com>
 <20140603074710.GA30870@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603074710.GA30870@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:47:10AM -0700, Sukadev Bhattiprolu wrote:

SNIP

> | 
> | 
> | could you please change this, so it's nop for arch != powerpc
> | via #ifdef I guess.. or some other smart way ;-)
> 
> I was trying to avoid the #ifdef in the middle of the function.
> 
> How about adding a PERF_CONTEXT_IGNORE and doing something like this:

hum, 2 arch calls.. seems too complicated.. :-\

so if you are already introducing PERF_CONTEXT_IGNORE, why
dont we go with the chain duplication/fixing in arch code
you mentioned before?

this way the callchain loop stays simple and it's extendbable
to future changes (I think u mentioned we could change more
than one entry in future..?)

thoughts.. anyone? ;-)

thanks,
jirka
