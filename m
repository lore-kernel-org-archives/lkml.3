Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaJBQSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:18:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49304 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752854AbaJBQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:18:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: cpufreq v3.17-rc7 error: "cpufreq: cpufreq_resume: Failed to start governor for policy: f6909a00"
Date: Thu, 02 Oct 2014 18:38:15 +0200
Message-ID: <2550705.C9YWxWdtP6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412250911.3060.13.camel@x41>
References: <1412250350.3060.9.camel@x41> <1412250911.3060.13.camel@x41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 01:55:11 PM Paul Bolle wrote:
> Paul Bolle schreef op do 02-10-2014 om 13:45 [+0200]:
> > Running v3.17-rc7 I see a new (for me) error, apparently during each
> > resume (from suspend) or thaw (from hibernate):
> >      cpufreq: cpufreq_resume: Failed to start governor for policy: f6909a00
> 
> So there are only two recent commits:
>     7106e02baed4 ("cpufreq: release policy->rwsem on error")
>     8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for
>         intel_pstate")
> 
> Would it be useful to test whether reverting the oldest commit,
> 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate"),
> changes anything?

Can you please try linux-pm.git/linux-next?  There's a commit from Viresh in
there with a chance to fix this and which I'm going to push to Linus shortly?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
