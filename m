Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3HTRLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:11:31 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:59947 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:11:30 -0400
Date: Tue, 20 Aug 2013 14:11:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
Message-ID: <20130820171118.GE8488@ghostprotocols.net>
References: <1377010076-21509-1-git-send-email-dsahern@gmail.com>
 <20130820145156.GC8488@ghostprotocols.net>
 <521397DE.5010306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521397DE.5010306@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 20, 2013 at 10:22:54AM -0600, David Ahern escreveu:
> On 8/20/13 8:51 AM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Aug 20, 2013 at 08:47:56AM -0600, David Ahern escreveu:
> >>Common arguments like thread id, CPU list, mmap pages, etc should be
> >>consistent across perf commands.

> >>Signed-off-by: David Ahern <dsahern@gmail.com>
> >>  tools/perf/builtin-trace.c |   12 ++++++------

> >  tools/perf/Documentation/perf-trace.txt part missing :-)

> grrrr... Added a check in the git pre-commit hook to remind me:
> 
> $ git commit -a
> changing command line arguments. Did you update the man page?

Hey, post it somewhere, please! I'd like to use it too. :-)
 
> Will resend later today.
> David
