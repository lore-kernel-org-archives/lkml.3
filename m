Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaBRL1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:27:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBRL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:27:22 -0500
Date: Tue, 18 Feb 2014 12:27:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: A feature to enhance lockdep function
Message-ID: <20140218112717.GB27965@twins.programming.kicks-ass.net>
References: <53033559.2090302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53033559.2090302@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 06:26:33PM +0800, xiaofeng.yan wrote:
> From the above information we can get what does really matter rapidly
> when hung-task information.
> This case may be simple. Developer couldn't know the reason why
> hung-task happen in complex environment.
> 
> I don't know whether this feature is  helpful or not in debug stage.

So we already print the held lock information, and its usually pretty
clear which lock we're trying to grab from the stack trace, which is
also already printed.


