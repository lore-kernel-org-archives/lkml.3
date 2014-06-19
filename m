Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaFSNKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:10:09 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45226 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaFSNKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:10:07 -0400
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file
 option
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20140619130202.GA24328@krava.brq.redhat.com>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
	 <1403178076-14072-6-git-send-email-jolsa@kernel.org>
	 <1403182604.1670.26.camel@leonhard>
	 <20140619130202.GA24328@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jun 2014 22:09:59 +0900
Message-ID: <1403183399.1670.30.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-19 (목), 15:02 +0200, Jiri Olsa:
> On Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim wrote:
> > [SNIP]
> > > @@ -35,6 +35,7 @@ struct symbol_conf symbol_conf = {
> > >  	.demangle		= true,
> > >  	.cumulate_callchain	= true,
> > >  	.symfs			= "",
> > > +	.show_headers		= -1,
> > 
> > Hmm.. why not just making it boolean and set it to true (like others)?
> 
> I need 'unset' value, otherwise I dont know if the config
> option was unset by user or not touched at all

I don't understand why you need it..  isn't it enough to check the
config option before using the value?

Thanks,
Namhyung


