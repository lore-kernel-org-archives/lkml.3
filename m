Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3KEOZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:25:53 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:36059 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3KEOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:25:51 -0500
Date: Tue, 5 Nov 2013 11:25:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131105142545.GD22912@ghostprotocols.net>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
 <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
 <20131105094220.GA1071@krava.brq.redhat.com>
 <5278EE0A.1080108@intel.com>
 <20131105133024.GE1071@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105133024.GE1071@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 05, 2013 at 02:30:24PM +0100, Jiri Olsa escreveu:
> On Tue, Nov 05, 2013 at 03:09:30PM +0200, Adrian Hunter wrote:
> > > right, I haven't considered the hundreds CPU machine.. I just
> > > saw that it disables inherited events in my test ;-) maybe we
> > > could mentioned that somewhere, because it's not clear
> > 
> > How about this:
> > 
> > From: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > By default, when tasks are specified (i.e. -p, -t
> > or -u options) per-thread mmaps are created.  Add
> > an option to override that and force per-cpu mmaps.
> > 
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> seems ok, thanks

Much better, but may I ask that the explanation in the man pages be
present in the changeset commit as well? So that by just looking at 'git
log' we can more readily get the whole picture, i.e. scalability versus
wanting to have inherit.

- Arnaldo
 
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> jirka
