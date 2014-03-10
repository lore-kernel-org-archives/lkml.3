Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaCJFhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:37:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:56908 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaCJFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokKJUt4UhC5_dJAhU3LCBwht4pfDWT5Lqo0T1-y_M31=A@mail.gmail.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
	<3894986.dK3STNSG71@vostro.rjw.lan>
	<CAKohpom+RUAi0jZBVWUEWZh36O4QgoJcK-YrCq6eDnfMVf+GCg@mail.gmail.com>
	<1456811.7asrQYHEt1@vostro.rjw.lan>
	<CAKohpokKJUt4UhC5_dJAhU3LCBwht4pfDWT5Lqo0T1-y_M31=A@mail.gmail.com>
Date: Mon, 10 Mar 2014 13:37:45 +0800
Message-ID: <CAKohponVBFaZY2tE8kJ91Gtj9MdvFKzGgWPNWxi38Kg8q9YUug@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2014 13:15, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 26 February 2014 03:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Yes, what exactly do we need it for in the core?
>
> Its probably there to make things faster. We cache the value so that we
> don't go to the hardware to read/calculate that again. Isn't it?
>
> And we need to know current freq on many occasions. One of that is that
> many drivers need to know the relation between current and new freq before
> they can make the change. As they might need to play with volt regulators
> before or after the freq change. Also it is used mainly in our loops_per_jiffiy
> calculations.

Ping!!
