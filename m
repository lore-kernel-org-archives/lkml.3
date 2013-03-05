Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3CEBmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:42:01 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51954 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3CEBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Mar 2013 09:41:59 +0800
Message-ID: <CAKohponLnEmEdUEJDYy840_X7WOBYcHybCCqibYFrFcj5gB=wA@mail.gmail.com>
Subject: Re: [PATCH 01/10] dmatest: cancel thread immediately when asked for
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 17:09, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> If user have the timeout alike issues and wants to cancel the thread
> immediately, the current call of wait_event_freezable_timeout is preventing to
> this until timeout is expired. Thus, user will experience the unnecessary
> delays.
>
> Adding kthread_should_stop() check inside wait_event_freezable_timeout() solves
> that.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
