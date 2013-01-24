Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3AXV3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:29:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3AXV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:28:59 -0500
Date: Thu, 24 Jan 2013 18:28:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2] tools lib traceevent: Handle dynamic array's element
 size properly
Message-ID: <20130124212840.GD14382@infradead.org>
References: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
 <1359061993.21576.156.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359061993.21576.156.camel@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 24, 2013 at 04:13:13PM -0500, Steven Rostedt escreveu:
> On Thu, 2013-01-24 at 21:46 +0100, Jiri Olsa wrote:
> >  
> > +static unsigned int type_size(char *name)
> 
> Sorry to nitpick, but please make that const char *name.

Agreed, no need to resubmit, I'll fix that up.

> The rest looks good.

Thanks, adding your Acked-by,

- Arnaldo
