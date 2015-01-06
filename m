Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbbAFN0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:26:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:48490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbbAFN0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:26:43 -0500
Date: Tue, 6 Jan 2015 10:26:37 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 1/4] tools/perf: support parsing parameterized events
Message-ID: <20150106132637.GB9975@kernel.org>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141222143710.GA29096@krava.brq.redhat.com>
 <20141222193045.GA19784@us.ibm.com>
 <20141223095506.GB22265@krava.brq.redhat.com>
 <20141223195850.GA26952@us.ibm.com>
 <20150106094220.GB19868@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106094220.GB19868@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 06, 2015 at 10:42:20AM +0100, Jiri Olsa escreveu:
> On Tue, Dec 23, 2014 at 11:58:50AM -0800, Sukadev Bhattiprolu wrote:
> > From a24b480ff54381a7e092597864cf615162afdd60 Mon Sep 17 00:00:00 2001
> > From: Cody P Schafer <cody@linux.vnet.ibm.com>
> > Date: Wed, 24 Sep 2014 12:27:15 -0700
> > Subject: [PATCH 1/4] tools/perf: support parsing parameterized events
> > 
> > Enable event specification like:
> > 
> > 	pmu/event_name,param1=0x1,param2=0x4/
> > 
> > Assuming that
> > 
> > 	/sys/bus/event_source/devices/pmu/events/event_name
> > 
> > Contains something like
> > 
> > 	param2=?,bar=1,param1=?
> > 
> > Changelog[v6]:
> > 	[Jiri Olsa] Add a check to make sure that sysfs entries with
> > 	parameters exactly match '=?'.
> > 
> > Changelog[v4]:
> > 	[Jiri Olsa] Merge to recent perf-core and fix a small conflict.
> > 
> > Changelog[v3]:
> > 	[Jiri Olsa] If the sysfs event file specifies 'param=val', make the
> > 	usage 'hv_24x7/event,param=123/' rather than 'hv_24x7/event,val=123/'.
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> 
> I'm ok with whole patchset, with some nits for patch 2
> that I've already sent out..
> 
> Would you mind sending v7 so we avoid confusion for Arnaldo
> what to pick up?

Yes, please, I'm trying to pick up what has accumulated over the
holidays,

- Arnaldo
