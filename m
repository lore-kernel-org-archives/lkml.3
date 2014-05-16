Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaEPWqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:46:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65259 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754706AbaEPWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:46:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Sat, 17 May 2014 01:03:32 +0200
Message-ID: <200048151.0RTJzuPcGp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomYMcisB-UHp7TOEdxvQ9-1VzyRshQh=P-dQqYOuBz-5g@mail.gmail.com>
References: <1400237477-24831-1-git-send-email-chander.kashyap@linaro.org> <CAKohpomYMcisB-UHp7TOEdxvQ9-1VzyRshQh=P-dQqYOuBz-5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 04:43:31 PM Viresh Kumar wrote:
> On 16 May 2014 16:21, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> > In of_init_opp_table function, if a failure to add an OPP is
> > detected, the count of OPPs, yet to be added is not updated.
> > Fix this by decrementing this count on failure as well.
> >
> > Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> > Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> > ---
> >  drivers/base/power/opp.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Is this -stable material?  If so, which -stable?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
