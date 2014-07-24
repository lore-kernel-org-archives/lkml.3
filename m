Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaGXTOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:14:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:54241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbaGXTOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:14:40 -0400
Date: Thu, 24 Jul 2014 16:14:36 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
Message-ID: <20140724191436.GF7831@kernel.org>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org>
 <20140724125751.GC7652@krava.brq.redhat.com>
 <20140724135747.GS20303@kernel.org>
 <20140724144906.GA25165@krava.brq.redhat.com>
 <CAM9d7cjnxBEsEmm2-QdXBNzxy402R-rbSHJ7bmi0njeTe0LW7g@mail.gmail.com>
 <20140724155843.GE25165@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724155843.GE25165@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 24, 2014 at 05:58:44PM +0200, Jiri Olsa escreveu:
> On Fri, Jul 25, 2014 at 12:41:15AM +0900, Namhyung Kim wrote:
> > On Thu, Jul 24, 2014 at 11:49 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > > On Thu, Jul 24, 2014 at 10:57:47AM -0300, Arnaldo Carvalho de Melo wrote:
> > >> Em Thu, Jul 24, 2014 at 02:57:51PM +0200, Jiri Olsa escreveu:
> > >> >  struct sort_entry sort_thread = {
> > >> >     .se_header      = "Command:  Pid",
> > >> > +   .se_header_right= true,

> > >> Is this just for the header? Perhaps its more clearly named .se_right_justify?

> > > yep, it's just for header.. let's see Namhyung might have better
> > > idea how to handle this problem

> > I think it still needs to be left-aligned.  So I'd rather change the

Good, I like simpler fixes :)

> > order - i.e. "Pid: Command".  Is it okay for you?
 
> yes, jirka

Yes, its is more usual to have pid+command anyway, just run 'ps' :-)

- Arnaldo
