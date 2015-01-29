Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbbA2E2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:28:47 -0500
Received: from ozlabs.org ([103.22.144.67]:51112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbbA2E2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:28:45 -0500
Message-ID: <1422505723.6621.6.camel@ellerman.id.au>
Subject: Re: [PATCH v7 0/4] Add support for parametrized events
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 29 Jan 2015 15:28:43 +1100
In-Reply-To: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 17:43 -0800, Sukadev Bhattiprolu wrote:
> Description of "event parameters" from the documentation patch:
> 
> Cody P Schafer (6):
>   perf: provide sysfs_show for struct perf_pmu_events_attr
>   perf: add PMU_EVENT_ATTR_STRING() helper
>   powerpc/perf/hv-24x7: parse catalog and populate sysfs with events
>   powerpc/perf/{hv-gpci, hv-common}: generate requests with counters
>     annotated
>   powerpc/perf/hv-gpci: add the remaining gpci requests
>   powerpc/perf/hv-24x7: Document sysfs event description entries
> 
> Sukadev Bhattiprolu (1):
>   perf: define EVENT_DEFINE_RANGE_FORMAT_LITE helper


Hi Sukadev,

I realise Cody wrote most of these and you are just getting them merged, but
they still need to be Signed-off-by you. Most of them aren't.

So please resend with them all signed off by you.

While you're at it, please drop all the CC lines, and move the changelog
annotations below the --- line so they are dropped when I apply them.

Also add Jiri's ack to the first two patches.

You can probably trim the CC list when you repost, I think everyone's seen this
series enough times.

cheers


