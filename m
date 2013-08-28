Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3H1NDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:03:05 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:41129 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3H1NDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:03:03 -0400
Date: Wed, 28 Aug 2013 10:02:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf trace: Add option to analyze events in a file
 versus live
Message-ID: <20130828130258.GC31260@ghostprotocols.net>
References: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
 <1377575535-43544-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377575535-43544-3-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 26, 2013 at 09:52:14PM -0600, David Ahern escreveu:
> Allows capture of raw_syscall:* events and analyzed at a later
> time.
>  
> +-r
> +--replay
> +	Process events from a given perf data file.

Shouldn't this be just -i/--input, like for 'report', 'annotate', etc?

- Arnaldo
