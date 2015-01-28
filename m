Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbbA1Ayl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:54:41 -0500
Received: from ozlabs.org ([103.22.144.67]:57572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbbA1Ayk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:54:40 -0500
Message-ID: <1422406478.32234.0.camel@ellerman.id.au>
Subject: Re: [PATCH v7 0/4] Add support for parametrized events
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 28 Jan 2015 11:54:38 +1100
In-Reply-To: <20150127100213.GC7810@krava.brq.redhat.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
	 <20150127100213.GC7810@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 11:02 +0100, Jiri Olsa wrote:
> On Mon, Jan 26, 2015 at 05:43:03PM -0800, Sukadev Bhattiprolu wrote:
> 
> SNIP
> 
> > 
> > 
> > Cody P Schafer (6):
> >   perf: provide sysfs_show for struct perf_pmu_events_attr
> >   perf: add PMU_EVENT_ATTR_STRING() helper
> >   powerpc/perf/hv-24x7: parse catalog and populate sysfs with events
> >   powerpc/perf/{hv-gpci, hv-common}: generate requests with counters
> >     annotated
> >   powerpc/perf/hv-gpci: add the remaining gpci requests
> >   powerpc/perf/hv-24x7: Document sysfs event description entries
> > 
> > Sukadev Bhattiprolu (1):
> >   perf: define EVENT_DEFINE_RANGE_FORMAT_LITE helper
> 
> generic 'perf: *' patches look good to me.. cant say much about
> the rest of the patchset though

Is that an ACK ?

I'm happy to merge the rest through the powerpc tree, but I'd like an ACK on
the first two from someone in perf land.

cheers


