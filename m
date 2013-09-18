Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3IRJPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:15:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38244 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3IRJPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:15:11 -0400
Date: Wed, 18 Sep 2013 11:15:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <minggr@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, "; John Stultz" <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] seqlock: add lockdep support
Message-ID: <20130918091504.GM12926@twins.programming.kicks-ass.net>
References: <1379487433.19121.29.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379487433.19121.29.camel@minggr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 02:57:13PM +0800, Lin Ming wrote:
> Hi,
> 
> lockdep support for seqlock was discussed at:
> http://marc.info/?l=linux-kernel&m=137875860600648&w=2
> 
> This is very draft patch to add lockdep support for seqlock.
> Actually, it doesn't work yet. I throw it out to get comments and help.
> 
> TODO:
> - fix seqlock usage in vdso code
> 
> I got below with this patch applied.
> There should be something wrong with this patch.
> Any idea?

You're aware of John Stultz's patches? 

lkml.kernel.org/r/1379117948-7385-1-git-send-email-john.stultz@linaro.org
