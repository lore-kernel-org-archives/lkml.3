Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3BVC1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:27:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41157 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab3BVC1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:27:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Subject: Re: [PATCH V2 4/4] cpufreq: Get rid of "struct global_attr"
Date: Fri, 22 Feb 2013 03:33:56 +0100
Message-ID: <10415300.xy5iOWqAMD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponQ0MVwbTpM-6MasewMQ7MWcL-3nFjf2d7DpAZbWKsNqw@mail.gmail.com>
References: <cover.1360568193.git.viresh.kumar@linaro.org> <31684733.Z4gjoGKC1g@vostro.rjw.lan> <CAKohponQ0MVwbTpM-6MasewMQ7MWcL-3nFjf2d7DpAZbWKsNqw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 07:47:44 AM Viresh Kumar wrote:
> On 22 February 2013 05:15, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Why did you change all of the lines of this macro instead of changing just the
> > one line you needed to change?
> 
> I didn't like the indentation used within the macro. So did it.

In general, things like that are for separate cleanup patches.  If you mix
functional changes with cleanups, poeple get confused and it's difficult to see
what's needed and what's "optional".

I know it's tempting to fix stuff like that along with doing functional
changes and I do that sometimes.  Not very often, though, and with care.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
