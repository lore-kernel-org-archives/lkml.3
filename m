Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3AXW6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:58:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab3AXW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:58:47 -0500
Date: Thu, 24 Jan 2013 19:58:28 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2] tools lib traceevent: Handle dynamic array's element
 size properly
Message-ID: <20130124225828.GE14382@infradead.org>
References: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
 <1359061993.21576.156.camel@gandalf.local.home>
 <20130124212840.GD14382@infradead.org>
 <1359063185.21576.157.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359063185.21576.157.camel@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 24, 2013 at 04:33:05PM -0500, Steven Rostedt escreveu:
> On Thu, 2013-01-24 at 18:28 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jan 24, 2013 at 04:13:13PM -0500, Steven Rostedt escreveu:
> > > On Thu, 2013-01-24 at 21:46 +0100, Jiri Olsa wrote:
> > > >  
> > > > +static unsigned int type_size(char *name)
> > > 
> > > Sorry to nitpick, but please make that const char *name.
> > 
> > Agreed, no need to resubmit, I'll fix that up.
> 
> I'm sure Tom St Denis appreciates it.
> 
> > 
> > > The rest looks good.
> > 
> > Thanks, adding your Acked-by,
> 
> Sure. But I probably should test it too ;-)

ROFL

- Arnaldo
