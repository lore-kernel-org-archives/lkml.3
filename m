Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3FGJCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab3FGJCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:02:03 -0400
Date: Fri, 7 Jun 2013 11:01:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 11/16] perf util: Parse header_page to get proper long
 size
Message-ID: <20130607090138.GA1071@krava.brq.redhat.com>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
 <1370323231-14022-12-git-send-email-namhyung@kernel.org>
 <20130606153737.GA1011@krava.brq.redhat.com>
 <87mwr22tav.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwr22tav.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:56:08PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Thu, 6 Jun 2013 17:37:37 +0200, Jiri Olsa wrote:
> > On Tue, Jun 04, 2013 at 02:20:26PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >> 
> >> The header_page file describes the format of the ring buffer page
> >> which is used by ftrace (not perf).  And size of "commit" field (I
> >> guess it's older name was 'size') represents the real size of long
> >> type used for kernel.  So update the pevent's long size.
> >> 
> > any reason why not merge this one with
> >   83ae6eb perf util: Skip reading header_event file
> 
> Just try to keep it doing one thing in a patch.  But if you think it'd
> better merging it, I'll do it. :)

nope, just curious if I missed something ;-) it's ok

jirka
