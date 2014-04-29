Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaD2WWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:22:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51371 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756381AbaD2WWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:22:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Fix checkpatch warnings
Date: Wed, 30 Apr 2014 00:39:11 +0200
Message-ID: <4780344.RfsAca3Qz3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5357C5E0.1070207@semaphore.gr>
References: <5356DB92.1060600@semaphore.gr> <2606012.9SjvfKiI5Z@vostro.rjw.lan> <5357C5E0.1070207@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 04:53:36 PM Stratos Karafotis wrote:
> On 23/04/2014 01:37 μμ, Rafael J. Wysocki wrote:
> > On Wednesday, April 23, 2014 12:13:54 AM Stratos Karafotis wrote:
> >> Fix the following checkpatch warnings:
> > 
> > In addition to comments from Viresh, I have a general one.
> > 
> > Some of the checkpatch.pl warnings are not worth fixing at all ->
> > 
> >> - WARNING: Prefer pr_err(... to printk(KERN_ERR ...
> >> - WARNING: Prefer pr_info(... to printk(KERN_INFO ...
> >> - WARNING: Prefer pr_warn(... to printk(KERN_WARNING ...
> >> - WARNING: quoted string split across lines
> >> - WARNING: line over 80 characters
> > 
> > -> and the "line over 80 characters" ones are outright wrong in many cases,
> > so please don't "fix" them.
> > 
> 
> Hi Rafael,
> 
> Thanks for your comments!
> 
> Could you please clarify if you want me to drop the entire patch or
> send it only with the changes about the last warning found ("no spaces
> at the start of a line)?
> 
> Also, I would like to take the opportunity and ask a question. :)
> 
> Reading the code, sometimes, I find some minor formatting issues.
> Like the checkpatch warnings or unnecessary parentheses and braces.
> 
> For example the line bellow:
> 		if ((freq < policy->min) || (freq > policy->max))
> 
> I know that this is not actually an issue and a patch with such changes
> is (somehow) a noise for the maintainers. But, should it be "fixed" or not?

It should be cleaned up generally, so if you have the time and you're willing
to do such things, please do them.

That said things like lines in excess of 80 characters may stay as they are.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
