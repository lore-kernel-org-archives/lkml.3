Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaBYWOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:14:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54616 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752978AbaBYWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:14:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
Date: Tue, 25 Feb 2014 23:29:28 +0100
Message-ID: <1456811.7asrQYHEt1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpom+RUAi0jZBVWUEWZh36O4QgoJcK-YrCq6eDnfMVf+GCg@mail.gmail.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <3894986.dK3STNSG71@vostro.rjw.lan> <CAKohpom+RUAi0jZBVWUEWZh36O4QgoJcK-YrCq6eDnfMVf+GCg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 08:12:52 PM Viresh Kumar wrote:
> On 25 February 2014 18:40, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > Well, why exactly does the core need to operate "current frequency" at all?
> 
> I don't think I understood what you meant here. Do you mean why should
> we maintain policy->cur?

Yes, what exactly do we need it for in the core?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
