Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3JDMjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:39:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:53617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3JDMjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:39:45 -0400
Date: Fri, 4 Oct 2013 14:39:28 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, paul.mckenney@linaro.org,
        tj@kernel.org, mingo@redhat.com, peterz@infradead.org,
        Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
Message-ID: <20131004123928.GD19953@linutronix.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpokzTj-=2BgrAH4UabiCAe_sZXhdyKu1L-VDnYBJ97BAyA@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Viresh Kumar | 2013-08-07 15:25:55 [+0530]:

>On 24 July 2013 14:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 18 June 2013 10:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
>> Hi Thomas,
>>
>> Do you still see some light of hope in this patch :) ?
>
>Ping!!

tglx, could you please take a look at this patch / thread?

Sebastian
