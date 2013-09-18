Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3IRJfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:35:55 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35906 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3IRJfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:35:54 -0400
Subject: Re: [RFC PATCH] seqlock: add lockdep support
From: Lin Ming <minggr@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130918091504.GM12926@twins.programming.kicks-ass.net>
References: <1379487433.19121.29.camel@minggr>
	 <20130918091504.GM12926@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 18 Sep 2013 17:29:51 +0800
Message-ID: <1379496591.19121.31.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 11:15 +0200, Peter Zijlstra wrote:
> On Wed, Sep 18, 2013 at 02:57:13PM +0800, Lin Ming wrote:
> > Hi,
> > 
> > lockdep support for seqlock was discussed at:
> > http://marc.info/?l=linux-kernel&m=137875860600648&w=2
> > 
> > This is very draft patch to add lockdep support for seqlock.
> > Actually, it doesn't work yet. I throw it out to get comments and help.
> > 
> > TODO:
> > - fix seqlock usage in vdso code
> > 
> > I got below with this patch applied.
> > There should be something wrong with this patch.
> > Any idea?
> 
> You're aware of John Stultz's patches? 

No.

Glad that John has wrote this.
Reading it ...

Thanks for the info.

> 
> lkml.kernel.org/r/1379117948-7385-1-git-send-email-john.stultz@linaro.org


