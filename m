Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946018AbaD3T7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:59:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52899 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1945984AbaD3T7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:59:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Fix checkpatch warnings
Date: Wed, 30 Apr 2014 22:16:14 +0200
Message-ID: <2559921.qEXZdngR08@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponkTeEqdgqJ6+caQcKd5yoMNhFvkZib1UueqNBCmO=pmA@mail.gmail.com>
References: <5356DB92.1060600@semaphore.gr> <4780344.RfsAca3Qz3@vostro.rjw.lan> <CAKohponkTeEqdgqJ6+caQcKd5yoMNhFvkZib1UueqNBCmO=pmA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 09:34:03 AM Viresh Kumar wrote:
> On 30 April 2014 04:09, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > It should be cleaned up generally, so if you have the time and you're willing
> > to do such things, please do them.
> >
> > That said things like lines in excess of 80 characters may stay as they are.
> 
> I have tried this sort of stuff earlier, but there is one issue that stands
> up again and again. When you update neighboring lines of lines
> crossing 80 columns, we do get warnings for lines which aren't actually
> updated by us (from checkpatch.pl). So, probably we need to fix
> checkpatch then..

That has been my opinion pretty much forever.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
