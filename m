Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaLWDON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:14:13 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33224 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaLWDOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:14:12 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 23 Dec 2014 12:14:50 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        acme@kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Remove some
 unused functions
Message-ID: <20141223031450.GA14960@sejong>
References: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145210.GA2188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141222145210.GA2188@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Rickard,

On Mon, Dec 22, 2014 at 12:52:10PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Sat, Dec 20, 2014 at 01:45:41PM +0100, Rickard Strandqvist escreveu:
> > Removes some functions that are not used anywhere:
> > pevent_get_any_field_val() pevent_get_common_field_val() pevent_event_fields() pevent_event_common_fields() pevent_list_events() pevent_print_event() pevent_data_event_from_type() pevent_register_trace_clock() pevent_pid_is_registered()
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> 
> Steven, Namhyung, Jiri:
> 
> Are you ok with me applying this patch? I'm all for it, dead code better
> be removed, but I don't know what are your plans wrt synchronization
> with the trace-cmd repo.

They're used by trace-cmd..  Currently Steve backports changes in
libtraceevent to trace-cmd repo occasionally but it eventually will be
a generic standalone library so I'd like to keep the APIs.

Thanks,
Namhyung
