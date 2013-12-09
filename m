Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3LISl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:41:28 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:41601 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3LISl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:41:27 -0500
Date: Mon, 9 Dec 2013 15:41:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls
 from parse-filter.c
Message-ID: <20131209184119.GD8098@ghostprotocols.net>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
 <20131209112449.47eeedaa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209112449.47eeedaa@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 11:24:49AM -0500, Steven Rostedt escreveu:
> On Mon,  9 Dec 2013 14:33:57 +0900 Namhyung Kim <namhyung@kernel.org> wrote:
> > This patchset tries to remove all die() calls in event filter parsing
> > code.  The only remaining bits are in trace-seq.c which implement
> > print functions and I want to hear what's the best way we can handle
> > the error case during the print.

> Other than what I commented on, the rest can have my:
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Added this to all the ones I applied, Namhyung, please address the other
concerns and check which ones were not applied so that you can have them
in your next request.

Thanks a lot!

- Arnaldo
