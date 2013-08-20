Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3HTOnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:43:55 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:39107 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3HTOny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:43:54 -0400
Date: Tue, 20 Aug 2013 11:43:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
Message-ID: <20130820144348.GB8488@ghostprotocols.net>
References: <1376931870-19912-1-git-send-email-dsahern@gmail.com>
 <20130819190603.GA1959@ghostprotocols.net>
 <52137AF2.5070907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52137AF2.5070907@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 20, 2013 at 08:19:30AM -0600, David Ahern escreveu:
> On 8/19/13 1:06 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Aug 19, 2013 at 11:04:30AM -0600, David Ahern escreveu:
> >>Common arguments like thread id, CPU list, mmap pages, etc should be
> >>consistent across perf commands.

> >Ok, at some point I'll add a 'perf strace' alias that will resume trying
> >to map the 'strace' single letter options.

> >Can you check if this clashes with the -o patch I added today?

> I just did remote update again and I do not see a -o patch in any of
> the branches.

Sorry, I thought I pushed it, did it now.

- Arnaldo
