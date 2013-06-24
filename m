Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3FXTpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:45:16 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57639 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3FXTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:45:15 -0400
Date: Mon, 24 Jun 2013 21:45:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130624194510.GC4065@gmail.com>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624152557.GU28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jun 11, 2013 at 06:42:26PM +0200, Robert Richter wrote:
> 
> Oh and what Boris and Ingo said; persistent events should 'persist' and
> not be tied to particular processes. I'm not sure about the entire
> eventfs thing; but the proposed sysfs thing should definitely work for
> now.

I'm fine with a sysfs approach as well, as long as it's correct and 
obvious enough to use.

Thanks,

	Ingo
