Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIYJ0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:26:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIYJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:26:36 -0400
Date: Thu, 25 Sep 2014 11:26:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, cebbert.lkml@gmail.com
Subject: Re: [PATCH v7 0/6] perf: add ability to sample interrupted machine
 state
Message-ID: <20140925092629.GC4140@worktop.programming.kicks-ass.net>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411559322-16548-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These do indeed appear to compile just fine, thanks!

Arnaldo, may I gently prod you to pass judgement over the tools bits?
