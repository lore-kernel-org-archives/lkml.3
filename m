Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3DAWYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010Ab3DAWYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:24:23 -0400
Date: Tue, 2 Apr 2013 00:00:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/27] perf tools: Move arch check into config/Makefile
Message-ID: <20130401220000.GB20943@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-4-git-send-email-jolsa@redhat.com>
 <1364853266.1728.6.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364853266.1728.6.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:54:26AM +0900, Namhyung Kim wrote:
> Hi, Jiri
> 
> 2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> > Moving arch check into config/Makefile.
> 
> [SNIP]
> 
> > +ifeq ($(filter clean tags,$(MAKECMDGOALS)),)
> > +include config/Makefile
> >  endif
> 
> Problem with this approach is that people (including me) sometimes give
> multiple targets in one go - like "make clean all".

ok, haven't thought of that ;-) I think this could be fixed

thanks,
jirka
