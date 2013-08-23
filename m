Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3HWLeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:34:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab3HWLeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:34:02 -0400
Date: Fri, 23 Aug 2013 13:34:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Vince Weaver <vince@deater.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130823113400.GA20310@nazgul.tnic>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130823104441.GD10223@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:44:41PM +0200, Robert Richter wrote:
> On 23.08.13 11:45:56, Robert Richter wrote:
> > On 23.08.13 11:11:28, Borislav Petkov wrote:
> > > On Thu, Aug 22, 2013 at 02:18:06PM -0400, Vince Weaver wrote:
> > > >   PERF_EVENT_IOC_MAKE_PERSISTENT
> > > >   PERF_EVENT_IOC_UNPERSIST
> 
> Maybe this?
> 
>  PERF_EVENT_IOC_PERSIST
>  PERF_EVENT_IOC_UNPERSIST

No, ATTACH/DETACH actually describes what you do with the fds and is
most generic. "PERSIST*" is a special use case of attaching/detaching
events.

Thanks.
