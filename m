Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3EaPs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:48:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43850 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3EaPsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:48:20 -0400
Date: Fri, 31 May 2013 17:48:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andrew Hunter <ahh@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH] perf: reduce stack usage of schedule_events
Message-ID: <20130531154815.GG27176@twins.programming.kicks-ass.net>
References: <1369332423-4400-1-git-send-email-ahh@google.com>
 <CABPqkBT6Hsq9ttSAP_c7R_GOEOCECu3Di_gjwvveFVrfVRTP+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT6Hsq9ttSAP_c7R_GOEOCECu3Di_gjwvveFVrfVRTP+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 04:21:04PM +0200, Stephane Eranian wrote:
> Hi,
> 
> Any comment on this patch?
> It does really help with stack pressure and will help fix a PEBS-LL issue.

Yeah, its on my todo list, but I've been spending all of my time trying
to fix all the bugs Vince has been throwing my way.


