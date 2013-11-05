Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3KENaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab3KENao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:30:44 -0500
Date: Tue, 5 Nov 2013 14:30:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131105133024.GE1071@krava.brq.redhat.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
 <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
 <20131105094220.GA1071@krava.brq.redhat.com>
 <5278EE0A.1080108@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278EE0A.1080108@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 03:09:30PM +0200, Adrian Hunter wrote:

SNIP

> >> Another advantage of per-thread mmaps is that you do not
> >> need to sample time (nor cpu), because the events are recorded
> >> in order.
> >>
> >> I was adding a feature.  Users can choose per-cpu mmaps if
> >> they want.
> > 
> > right, I haven't considered the hundreds CPU machine.. I just
> > saw that it disables inherited events in my test ;-) maybe we
> > could mentioned that somewhere, because it's not clear
> 
> How about this:
> 
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> By default, when tasks are specified (i.e. -p, -t
> or -u options) per-thread mmaps are created.  Add
> an option to override that and force per-cpu mmaps.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

seems ok, thanks

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
