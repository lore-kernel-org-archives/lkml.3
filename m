Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaEBLxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:53:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50646 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751733AbaEBLxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:53:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: peterz@infradead.org, mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it out
Date: Fri, 02 May 2014 14:09:35 +0200
Message-ID: <2782801.UzoMhgfu56@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53635CCB.9090301@linaro.org>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org> <2783362.8r7SvVhudq@vostro.rjw.lan> <53635CCB.9090301@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 10:52:27 AM Daniel Lezcano wrote:
> On 05/01/2014 12:47 AM, Rafael J. Wysocki wrote:
> > On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
> >> Encapsulate the large portion of cpuidle_idle_call inside another
> >> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
> >> Also that is benefitial for the clarity of the code as it removes
> >> a nested indentation level.
> >>
> >> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >
> > Well, this conflicts with
> >
> > https://patchwork.kernel.org/patch/4071541/
> >
> > which you haven't commented on and I still want cpuidle_select() to be able to
> > return negative values because of
> >
> > https://patchwork.kernel.org/patch/4089631/
> >
> > (and I have one more patch on top of these two that requires this).
> >
> > Any ideas how to resolve that?
> 
> I don't think we have a big conflict. If Peter takes your patches before 
> than mines then I will refresh and resend them.

Actually, I was planning the merge them myself, because they are more cpuidle
than the scheduler, but either way would be fine.

> I am open to any other suggestion.

Please see the other message I've just sent. :-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
