Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834Ab3DHLOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:14:51 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41971 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432Ab3DHLOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130408111328.GA12244@kernel.dk>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<20130408111328.GA12244@kernel.dk>
Date: Mon, 8 Apr 2013 16:44:47 +0530
Message-ID: <CAKohpompyx33F7WKjq3gXEpJs5BUxq6Md1hcd=h1ZxF0a6T5vg@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, davem@davemloft.net, airlied@redhat.com,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 16:43, Jens Axboe <axboe@kernel.dk> wrote:
> And lets please have it off by default. The specialized configs / setups
> can turn it on, but we should default to better performance.

Yes, we will.
