Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaJBPWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:22:12 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50975 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaJBPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:22:11 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
References: <1412245929-27579-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<1412245929-27579-2-git-send-email-yarygin@linux.vnet.ibm.com>
	<20141002141559.GJ9764@krava.brq.redhat.com>
Date: Thu, 02 Oct 2014 19:21:58 +0400
In-Reply-To: <20141002141559.GJ9764@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 2 Oct 2014 16:15:59 +0200")
Message-ID: <87tx3m7azt.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100215-4966-0000-0000-00000186D24A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

[..]

>
> looks ok.. but I was wondering if we could move those repeating
> bits in function.. something like below (untested, just compiled)
>
> thanks,
> jirka
>
>

[..]

Yep, it's better. Just checked - it works. How should we process?

Thanks.

