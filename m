Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3JWFzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:55:51 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40318 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3JWFzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131004123928.GD19953@linutronix.de>
References: <CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
	<CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com>
	<CAKohpo=0r=HY5w-XqnXv42eSJcH08C47J+TqWn7vY1aNBhGT_A@mail.gmail.com>
	<CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
	<alpine.LFD.2.02.1305131223470.2863@ionos>
	<CAKohpokfKPQ3EhMf3WB8koXuH2rF6QoejwNOTw08X+XfnVhpEg@mail.gmail.com>
	<CAKohpomoSHS0wSCBrJApZuSTr9fbm2py6WdNg1MNzRWjb55Y_Q@mail.gmail.com>
	<CAKohpon0dC6O_QBXnbyxUOO0DcrRxTzFkZSJNh6VrNL5kzT66Q@mail.gmail.com>
	<CAKohpomGSoU5VOcrbonD1=NE-6xDVr+pveAmuXdrzjmLotmEug@mail.gmail.com>
	<CAKohpokzTj-=2BgrAH4UabiCAe_sZXhdyKu1L-VDnYBJ97BAyA@mail.gmail.com>
	<20131004123928.GD19953@linutronix.de>
Date: Wed, 23 Oct 2013 11:25:49 +0530
Message-ID: <CAKohpoksr+E6X1AWpROBxGvasXQ5zXHqKM7Xr7QFO=tzkEkoWQ@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paul.mckenney@linaro.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        PDSW-power-team <pdsw-power-team@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2013 18:09, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> tglx, could you please take a look at this patch / thread?

Thomas, Ping!!
