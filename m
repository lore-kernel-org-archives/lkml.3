Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3LZUwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:52:41 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:36806 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3LZUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:52:40 -0500
Date: Thu, 26 Dec 2013 17:52:31 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] tools: Factor traceevent/perf Makefile
Message-ID: <20131226205231.GA6283@ghostprotocols.net>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
 <20131226133842.GA30980@ghostprotocols.net>
 <20131226201007.GA1213@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226201007.GA1213@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 09:10:07PM +0100, Jiri Olsa escreveu:
> On Thu, Dec 26, 2013 at 10:38:42AM -0300, Arnaldo Carvalho de Melo wrote:
> > Removing those two "Nothing to be done" lines, please?
> 
> never happy, are we? ;-) looks like change below
> would do.. I'll check/test more and send out.

Thanks! Now I'm happy! ;-)

- Arnaldo
