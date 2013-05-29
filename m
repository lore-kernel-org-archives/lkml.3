Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760Ab3E2L41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418Ab3E2L40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:56:26 -0400
Date: Wed, 29 May 2013 13:56:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Runzhen Wang <icycoder@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@kernel.org,
        dsahern@gmail.com, Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf tools: fix an error introduced by commit 93cbb398
Message-ID: <20130529115615.GA1232@krava.brq.redhat.com>
References: <1369668455-6246-1-git-send-email-icycoder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369668455-6246-1-git-send-email-icycoder@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 11:27:35PM +0800, Runzhen Wang wrote:
> commit 0a720538e5dd3f424bfcc15c1e4af09df0becf92
> and
> commit 93cbb3985d5de867fb32e6e130fcfb1b5de4142b
> move some contents of Makefile from perf/Makefile to
> perf/config/Makefile.

hi,
so you based on latest acme's perf/core, right?

I think it's fixed right now within the branch.
The issue was there and got fixed by using:

-BASIC_CFLAGS = \
+BASIC_CFLAGS += \


should work right now,

thanks,
jirka
