Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaINQqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:46:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53192 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752359AbaINQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:46:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        linux-pm@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [REPOST PATCH v4 1/2] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
Date: Sun, 14 Sep 2014 19:06:22 +0200
Message-ID: <3009588.qOkltIoajF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAObsKBkjqJiJ4OC4FYDXDBSFMFzvbvD_vJ6KzhqyyPCCB-o7g@mail.gmail.com>
References: <1409759373-22696-1-git-send-email-tomeu.vizoso@collabora.com> <1409759373-22696-2-git-send-email-tomeu.vizoso@collabora.com> <CAAObsKBkjqJiJ4OC4FYDXDBSFMFzvbvD_vJ6KzhqyyPCCB-o7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 12, 2014 11:11:25 AM Tomeu Vizoso wrote:
> On 3 September 2014 17:49, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> > Also adds a class type PM_QOS_SUM that aggregates the values by summing them.
> >
> > It can be used by memory controllers to calculate the optimum clock frequency
> > based on the bandwidth needs of the different memory clients.
> >
> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Hi Rafael,
> 
> will you take this one for 3.18?

Quite likely, but I'm traveling now, so I'll do that after I'm back home
in a few days.  I'll write to you if there are any problems.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
