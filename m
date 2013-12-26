Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3LZOzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:55:25 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:33988 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LZOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:55:24 -0500
Date: Thu, 26 Dec 2013 11:55:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131226145517.GH30980@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
 <20131223193757.GA1396@ghostprotocols.net>
 <52B8D582.9090009@gmail.com>
 <20131224125342.GC17780@ghostprotocols.net>
 <20131224133003.GA23382@ghostprotocols.net>
 <52BC390A.2000504@gmail.com>
 <20131226141507.GD30980@ghostprotocols.net>
 <52BC3AA9.1020404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC3AA9.1020404@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 09:18:17AM -0500, David Ahern escreveu:
> On 12/26/13, 9:15 AM, Arnaldo Carvalho de Melo wrote:
> >Right, but I can't apply that patch, as it makes 'perf stat
> >whatever-workload' to fail, as I realized when doing a demo to someone
> >interested in using perf ;-\
> >
> >So for now I'm not applying that one.
> 
> right, so you want one with < 0 check or wait for something else? I
> was not expecting to find it in your perf/core branch, yet there it
> is.

Shouldn't be anymore,

- Arnaldo
 
> >
> >Ah, at this point elves are everywhere, dammit! ;-)
> 
> An elf put it there?
> 
> David
