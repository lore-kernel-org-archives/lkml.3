Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670Ab3HHO5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:57:00 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:63826 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965455Ab3HHO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:56:58 -0400
Date: Thu, 8 Aug 2013 11:56:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/19] perf sched: Remove thread lookup in sample handler
Message-ID: <20130808145651.GF2851@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375930261-77273-4-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 10:50:45PM -0400, David Ahern escreveu:
> Not used in the function, so no sense in doing the lookup here. Thread look
> up will be done in the timehist command, and no sense in doing it twice.

Thanks, applied.
