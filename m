Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbbAPCEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:04:25 -0500
Received: from mail.kernel.org ([198.145.29.136]:57816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbbAPCEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:04:24 -0500
Date: Thu, 15 Jan 2015 23:04:18 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH v4] tools lib traceevent: Add support for IP address
 formats
Message-ID: <20150116020418.GA18698@kernel.org>
References: <1418955071-36241-1-git-send-email-dsahern@gmail.com>
 <54B7DD0A.8000402@gmail.com>
 <20150115104523.1b8897a8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115104523.1b8897a8@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 15, 2015 at 10:45:23AM -0500, Steven Rostedt escreveu:
> On Thu, 15 Jan 2015 08:30:18 -0700
> David Ahern <dsahern@gmail.com> wrote:
> 
> > Steve:
> > 
> > Any comments? I think Arnaldo is waiting for your response to pick this up.
> 
> Looks fine to me.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 

Thanks, I'll merge this into my perf/core branch soon.

- Arnaldo
