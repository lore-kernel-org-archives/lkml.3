Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaEUXbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:31:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62312 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753403AbaEUXbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:31:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH V5] PM/OPP: discard duplicate OPPs
Date: Thu, 22 May 2014 01:48:43 +0200
Message-ID: <5258228.rMTDJps2Fm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponU2feK9+9sUn4tu0t4fhwSy6PZuaAO3zkF7qRejCwM1Q@mail.gmail.com>
References: <7cb6e0e039e0935e37c81d0f23d26b0b81ad8cda.1400597170.git.viresh.kumar@linaro.org> <1555967.8fxByr2j83@vostro.rjw.lan> <CAKohponU2feK9+9sUn4tu0t4fhwSy6PZuaAO3zkF7qRejCwM1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2014 09:33:42 AM Viresh Kumar wrote:
> On 21 May 2014 02:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> +     /* Duplicate OPPs ? */
> >> +     if (new_opp->rate == opp->rate) {
> >> +             int ret = (new_opp->u_volt == opp->u_volt) && opp->available ?
> >> +                     0 : -EEXIST;
> >
> > The parens are not necessary.  And is the direction correct?
> 
> What do you mean by direction here ?

The case in which we want to return 0.  Never mind, it's OK.  The parens are still
not necessary, though.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
