Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaLWOGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:06:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbaLWOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:06:49 -0500
Date: Tue, 23 Dec 2014 10:28:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Remove some
 unused functions
Message-ID: <20141223132826.GM7644@kernel.org>
References: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145210.GA2188@redhat.com>
 <20141223031450.GA14960@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223031450.GA14960@sejong>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 23, 2014 at 12:14:50PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo and Rickard,
> 
> On Mon, Dec 22, 2014 at 12:52:10PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Sat, Dec 20, 2014 at 01:45:41PM +0100, Rickard Strandqvist escreveu:
> > > Removes some functions that are not used anywhere:
> > > pevent_get_any_field_val() pevent_get_common_field_val() pevent_event_fields() pevent_event_common_fields() pevent_list_events() pevent_print_event() pevent_data_event_from_type() pevent_register_trace_clock() pevent_pid_is_registered()
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Steven, Namhyung, Jiri:
> > 
> > Are you ok with me applying this patch? I'm all for it, dead code better
> > be removed, but I don't know what are your plans wrt synchronization
> > with the trace-cmd repo.
> 
> They're used by trace-cmd..  Currently Steve backports changes in
> libtraceevent to trace-cmd repo occasionally but it eventually will be
> a generic standalone library so I'd like to keep the APIs.

So there are plans to use them in the near future, ok.

- Arnaldo
