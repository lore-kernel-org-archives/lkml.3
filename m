Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558Ab3HHOzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:55:05 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:51862 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097Ab3HHOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:55:03 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 10:55:03 EDT
Date: Thu, 8 Aug 2013 11:54:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/19] perf sched: Simplify arguments to read_events
Message-ID: <20130808145456.GE2851@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375930261-77273-3-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 10:50:44PM -0400, David Ahern escreveu:
> Destroy argument is not necessary. If session is not returned to caller,
> then clean it up.

Thanks, applied.
