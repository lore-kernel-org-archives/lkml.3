Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBVJ1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 04:27:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaBVJ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 04:27:13 -0500
Date: Sat, 22 Feb 2014 10:27:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 9/9] trace: Replace hardcoding of 19 with MAX_NICE.
Message-ID: <20140222092703.GU9987@twins.programming.kicks-ass.net>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <eeb2a85d74c71e0d50c88789f99ad857a6b4b7b4.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <53086860.2010209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53086860.2010209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 05:05:36PM +0800, Dongsheng Yang wrote:
> Hi Peter.
>     It seems the all other patches in this set were all applied to tip
> except this one.
> What is the problem with the [9/9]? Is there any thing I can do?

I might have just missed it; fail on my end. I'll try and sort it on
monday.
