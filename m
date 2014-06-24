Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaFXMq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:46:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:52594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXMqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:46:25 -0400
Date: Tue, 24 Jun 2014 14:46:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/3] perf: Do not allow optimized switch for non-cloned
 events
Message-ID: <20140624124621.GM19860@laptop.programming.kicks-ass.net>
References: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
 <1403598026-2310-2-git-send-email-jolsa@kernel.org>
 <20140624103936.GK19860@laptop.programming.kicks-ass.net>
 <20140624105301.GB7554@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624105301.GB7554@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 12:53:01PM +0200, Jiri Olsa wrote:
> 
> should I queue it with your ack?

I picked up the lot.
