Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3GEOey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:34:54 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45575 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3GEOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:34:53 -0400
Date: Fri, 5 Jul 2013 11:34:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] perf: bug fixes, cleanup of parse events memory
 allocations
Message-ID: <20130705143446.GB2559@ghostprotocols.net>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 02, 2013 at 01:27:19PM -0600, David Ahern escreveu:
> David Ahern (6):
>   perf evsel: fix count parameter to read call in event_format__new
>   perf evlist: fix use of uninitialized variable
>   perf event: initialize allocated memory for synthesized events
>   perf: don't free list head in parse_events__free_terms
>   perf test: make terms a stack variable in test_term
>   perf parse events: demystify memory allocations

Thanks, applied,

- Arnaldo
