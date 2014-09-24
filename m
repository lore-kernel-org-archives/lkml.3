Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaIXImi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:42:38 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:60713 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaIXIme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <3009588.qOkltIoajF@vostro.rjw.lan>
References: <1409759373-22696-1-git-send-email-tomeu.vizoso@collabora.com>
 <1409759373-22696-2-git-send-email-tomeu.vizoso@collabora.com>
 <CAAObsKBkjqJiJ4OC4FYDXDBSFMFzvbvD_vJ6KzhqyyPCCB-o7g@mail.gmail.com> <3009588.qOkltIoajF@vostro.rjw.lan>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 24 Sep 2014 10:42:13 +0200
X-Google-Sender-Auth: hq5Q0f6Vm8lg_l46g-onPETfktc
Message-ID: <CAAObsKD1R_s2JkUgS+W+HBZe2hBTs=Co+d6o63YkmDMHXJCf=g@mail.gmail.com>
Subject: Re: [REPOST PATCH v4 1/2] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Terje_Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        linux-pm@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2014 19:06, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, September 12, 2014 11:11:25 AM Tomeu Vizoso wrote:
>> On 3 September 2014 17:49, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
>> > Also adds a class type PM_QOS_SUM that aggregates the values by summing them.
>> >
>> > It can be used by memory controllers to calculate the optimum clock frequency
>> > based on the bandwidth needs of the different memory clients.
>> >
>> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> > Acked-by: Pavel Machek <pavel@ucw.cz>
>>
>> Hi Rafael,
>>
>> will you take this one for 3.18?
>
> Quite likely, but I'm traveling now, so I'll do that after I'm back home
> in a few days.  I'll write to you if there are any problems.

Don't want to be annoying, but thought I might ping you just in case
this fell through the cracks.

Regards,

Tomeu
