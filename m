Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaK1JdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaK1JdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:33:09 -0500
Date: Fri, 28 Nov 2014 10:32:31 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
Message-ID: <20141128093231.GB25935@krava.brq.redhat.com>
References: <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
 <20141105125028.GA30087@linutronix.de>
 <545AEA37.601@voxpopuli.im>
 <5460156E.3050601@voxpopuli.im>
 <5463DBD5.9080303@voxpopuli.im>
 <20141127154302.GA4924@krava.brq.redhat.com>
 <54776E0A.1020508@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54776E0A.1020508@voxpopuli.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 01:31:38PM -0500, Alexandre Montplaisir wrote:
> 
> On 11/27/2014 10:43 AM, Jiri Olsa wrote:
> >On Wed, Nov 12, 2014 at 05:14:45PM -0500, Alexandre Montplaisir wrote:
> >>
> >>Testing welcome!
> >hi,
> >any other way besides compiling eclipse to test this? For pure mortals
> >with Fedora eclipse rpm.. ;-)
> 
> If you already have an Eclipse installation, you can use the update site:
> http://download.eclipse.org/tracecompass/master/nightly/
> This would install the plugins into that Eclipse install.
> 
> We will also put nightly builds of the stand-alone version on the download
> page Very Soon(TM). We just have a few issues left to figure out.

cool, I'll check

thanks,
jirka
