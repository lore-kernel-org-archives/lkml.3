Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaE0LNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:13:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64429 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751577AbaE0LNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:13:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V3 4/8] driver/core: cpu: initialize opp table
Date: Tue, 27 May 2014 13:30:09 +0200
Message-ID: <11801597.a0CDeJOEp5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpokZSw430PWjJfYOPA6KXOJiKFhxRi4BuEf6ouMgUHQ+gw@mail.gmail.com>
References: <cover.1400736536.git.viresh.kumar@linaro.org> <CAKohponagSjOVbn-C64yh7=py9kE0m2VGbdquo_1+UzbPFsJ+w@mail.gmail.com> <CAKohpokZSw430PWjJfYOPA6KXOJiKFhxRi4BuEf6ouMgUHQ+gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 05:48:27 AM Viresh Kumar wrote:
> On 27 May 2014 05:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > We are also using it for cpu->dev_id, but that's not so important. This
> > routine wouldn't have existed if you wouldn't have asked for it. It is
> > just a wrapper over of_init_opp_table, which also has a dummy
> > implementation when its not supported.
> >
> > So, it might not be worth enough for any other code to use it. :)
> > And so I added it here.
> >
> > Let me know how/where do you want it and I will resend it quickly.
> 
> There is another option here, add these print messages in
> of_init_opp_table() ? That's the only difference new wrapper has.

Yeah, put them into of_init_opp_table() rather I'd say.

Rafael

