Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3KKO7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:59:21 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:56272 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3KKO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:59:14 -0500
Date: Mon, 11 Nov 2013 11:59:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: Round mmap pages to power 2
Message-ID: <20131111145908.GC27198@ghostprotocols.net>
References: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
 <20131111112754.GD15810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111112754.GD15810@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 11, 2013 at 12:27:54PM +0100, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > Currently perf requires the -m / --mmap_pages option to be a power of 2.
> > To be more user friendly perf should automatically round this up to the
> > next power of 2.
> > 
> > Currently:
> >   $ perf record -m 3 -a -- sleep 1
> >   --mmap_pages/-m value must be a power of two.sleep: Terminated
> > 
> > With patch:
> >   $ perf record -m 3 -a -- sleep 1
> >   rounding mmap pages size to 16384 (4 pages)
> 
> Please add 'bytes'.

Ok, waiting for v2 with this and Adrian's concerns addressed.

- Arnaldo
