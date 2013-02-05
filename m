Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3BEKHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:07:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44021 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab3BEKHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:07:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Tue, 05 Feb 2013 11:13:17 +0100
Message-ID: <1535355.NvOsIhbBYp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=mWc9rBX3O_1NSr23TAWFtRA6BNW3TZ8FhZOMdH_0dmzQ@mail.gmail.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com> <3480441.gCEh0J5edK@vostro.rjw.lan> <CAOh2x=mWc9rBX3O_1NSr23TAWFtRA6BNW3TZ8FhZOMdH_0dmzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 05, 2013 03:28:30 PM Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 3:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > I actually don't agree with that, becuase the Nathan's apprach shows the
> > reasoning that leads to the RCU introduction quite clearly.  So if you
> > don't have technical problems with the patchset, I'm going to take it as is.
> 
> Great!!
> 
> Okay.. I don't have any technical problems with it, i reviewed most of it
> carefully. The only pending thing is rebase on linux-next, after that i can
> give my ack for it.

Yes, it would be great if it were rebased and retested.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
