Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3AXVdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:33:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31685 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3AXVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:33:07 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YyIrxvMppY0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=W0fAN9IbdjwA:10 a=U3mvYQgqbpKD95cSg6EA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359063185.21576.157.camel@gandalf.local.home>
Subject: Re: [PATCHv2] tools lib traceevent: Handle dynamic array's element
 size properly
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 24 Jan 2013 16:33:05 -0500
In-Reply-To: <20130124212840.GD14382@infradead.org>
References: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
	 <1359061993.21576.156.camel@gandalf.local.home>
	 <20130124212840.GD14382@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 18:28 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 24, 2013 at 04:13:13PM -0500, Steven Rostedt escreveu:
> > On Thu, 2013-01-24 at 21:46 +0100, Jiri Olsa wrote:
> > >  
> > > +static unsigned int type_size(char *name)
> > 
> > Sorry to nitpick, but please make that const char *name.
> 
> Agreed, no need to resubmit, I'll fix that up.

I'm sure Tom St Denis appreciates it.

> 
> > The rest looks good.
> 
> Thanks, adding your Acked-by,

Sure. But I probably should test it too ;-)

-- Steve


