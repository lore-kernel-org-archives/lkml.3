Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3IET0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab3IET0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:26:00 -0400
Date: Thu, 5 Sep 2013 16:25:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: torvalds@linux-foundation.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: builtin-trace.c: check if MAP_32BIT is defined
Message-ID: <20130905192555.GA3701@infradead.org>
References: <20130905142947.GA25882@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905142947.GA25882@merlin.infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 05, 2013 at 10:29:47AM -0400, Kyle McMartin escreveu:
> From: Kyle McMartin <kyle@redhat.com>
> 
> MAP_32BIT is defined only on x86... this means perf fails to build on
> all other platforms.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Thanks, applying.

- Arnaldo
