Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbaIELdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:33:49 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65269 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859AbaIELdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:33:47 -0400
Message-ID: <1409916824.7832.20.camel@x220>
Subject: Re: [PATCH 09/28] Remove ATHEROS_AR231X
From: Paul Bolle <pebolle@tiscali.nl>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Richard Weinberger <richard@nod.at>,
        Jonathan Bither <jonbither@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, ath5k-devel@venema.h4ckr.net,
        open@hauke-m.de, list@hauke-m.de, antonynpavlov@gmail.com,
        openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 13:33:44 +0200
In-Reply-To: <CAHNKnsRipRHicKOUW4dCutD1-sUG6qPnP2QuOveH_t1MFX9XgQ@mail.gmail.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-10-git-send-email-richard@nod.at>
	 <52F7D480.1050106@hauke-m.de> <52F7DF21.70207@nod.at>
	 <CAHNKnsS7Mv4ZhBWZa53go9L9nZimJ7_FG5HFJ9C3kkGMAEz-mA@mail.gmail.com>
	 <52F8C373.9060108@rempel-privat.de>
	 <CAHNKnsQF5Hdf3JT91moPraRQzn4kMpdD2NSiJ7b30wQhS1W4MA@mail.gmail.com>
	 <CAGVrzcYnECx5Q=i+m6qZn29y4JALDpw5SWoUNP-S6HgPR3_ygQ@mail.gmail.com>
	 <CAHNKnsRACSo=DfOyiHxqV3acv_wfZmz4tMnYAW0wo4OCibwdfA@mail.gmail.com>
	 <CAHNKnsRQp7WLSJNAXEYPTd=qs1DquOfNgKtHES-Utvcy1=FEgQ@mail.gmail.com>
	 <20140213201421.GJ22203@tuxdriver.com> <1397581703.8212.5.camel@x220>
	 <CAHNKnsQQ42-XnXrubHAy4PF3H2ynbGDdSMP7MvDS_1aRozYF=A@mail.gmail.com>
	 <1403087119.1984.93.camel@x220>
	 <CAHNKnsSfaT7xC5_wv=TrGLEQ2pjC91Q1XG891_n64OuR0fA9Jg@mail.gmail.com>
	 <1403091974.1984.102.camel@x220> <1409911856.7832.9.camel@x220>
	 <CAHNKnsRipRHicKOUW4dCutD1-sUG6qPnP2QuOveH_t1MFX9XgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 11:33:45.0400 (UTC) FILETIME=[40A6FB80:01CFC8FD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Fri, 2014-09-05 at 15:12 +0400, Sergey Ryazanov wrote:
> 2014-09-05 14:10 GMT+04:00, Paul Bolle <pebolle@tiscali.nl>:
> > On Wed, 2014-06-18 at 13:46 +0200, Paul Bolle wrote:
> >> Having this conversation every rc1 is getting a bit silly. Could Jiri
> >> e.a. perhaps set some specific deadline for ATHEROS_AR231X to be
> >> submitted?
> >
> > I waited until rc3. Have you seen any activity on this front? If not,
> > should I resend the patch that removes the code in mainline that depends
> > on ATHEROS_AR231X (ie, AHB bus support)?
> >
> Recent activity always could be found in [1]. Now I finish another one
> round of cleanups and have a plan to fix several things (you can
> always find something that you really want to improve). But if you
> insist I could immediately switch to "send upstream" mode. And seems
> that this would be better approach.
> 
> 1. https://dev.openwrt.org/log/trunk/target/linux/atheros

And where can the related PULL requests or patch submissions be found?


Paul Bolle

