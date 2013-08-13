Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3HMArv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:47:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64637 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3HMAru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130812154810.433858a5@gandalf.local.home>
References: <20130812163413.GI23040@linutronix.de> <20130812154810.433858a5@gandalf.local.home>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 12 Aug 2013 20:47:18 -0400
X-Google-Sender-Auth: UHeEHOcqBwCzxle9R_dYGWj2GlY
Message-ID: <CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 3:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 12 Aug 2013 18:34:13 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>
>> Dear RT folks!
>>
>> I'm pleased to announce the v3.10.6-rt3 patch set.
>
>
> Does this mean that I can drop 3.6-rt in favor of 3.8-rt?

I'd guess that the trade-off would be 3.0-rt against 3.8-rt.
The above comment assumes 3.0 is aged out vs. 3.6 kernel.

>
> I'm just about finished with a 3.6 stable, which I'll finish, add -rt
> to it, and then call it "unsupported" after that. Well, I may take bug
> fixes if people find any in the near future.
>
> I'm behind on 3.4-rt, 3.2-rt and of course 3.0-rt. Hopefully, I'll get
> them all out this week.

I expect that the 3.10-rt kernel will replace the older RT kernels.

>
> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
