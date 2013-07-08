Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3GHPrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:47:05 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39248 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GHPrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130708153716.GF29556@pengutronix.de>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<20130708153716.GF29556@pengutronix.de>
Date: Mon, 8 Jul 2013 21:17:01 +0530
Message-ID: <CAKohpon+dFBDUhfbJcBBWyg4mAfQ1nU_wSd6OMvdTH6SzkUjNg@mail.gmail.com>
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: tj@kernel.org, davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Livi@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2013 21:07, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> This patch set hit my tree now. I wonder if it makes sense to make
> WQ_POWER_EFFICIENT_DEFAULT depend on SMP. (Oh wait, big.LITTLE isn't
> SMP, so probably there is a better symbol to depend on?)

Well, big LITTLE still runs an SMP kernel :) and so has this flag set.
You can make it dependent on that if required.
