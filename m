Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966328AbaFRLqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:46:20 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60449 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933986AbaFRLqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:46:17 -0400
Message-ID: <1403091974.1984.102.camel@x220>
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
        open@hauke-m.de,
        "list@hauke-m.de:NETWORKING DRIVERS" <list@hauke-m.de>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jun 2014 13:46:14 +0200
In-Reply-To: <CAHNKnsSfaT7xC5_wv=TrGLEQ2pjC91Q1XG891_n64OuR0fA9Jg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 11:46:14.0923 (UTC) FILETIME=[E8C4DDB0:01CF8AEA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Wed, 2014-06-18 at 15:10 +0400, Sergey Ryazanov wrote:
> 2014-06-18 14:25 GMT+04:00 Paul Bolle <pebolle@tiscali.nl>:
> > ATHEROS_AR231X and the things depending on it, like AHB bus support,
> > have been discussed for three years now. When will you (re)consider a
> > patch to remove all currently dead code?
> >
> > And to state the obvious: AHB bus support, and the other code depending
> > on ATHEROS_AR231X, can always be re-added once ATHEROS_AR231X gets added
> > to the tree.
> 
> Work in progress, I don't stop it. Just work is progressing slower
> than I had planned. I am already cleanup the code (mostly checkpatch
> errors and warnings) and send patches to OpenWRT tree. Further I plan
> to simplify initialization and I will be ready to send patches
> upstream.

That's good to hear.

> I need a couple of weeks for this. Is its reasonable time to not make
> a mess of remove/add commits?

Removing the code just to re-add it shortly after would indeed be
awkward.

Having this conversation every rc1 is getting a bit silly. Could Jiri
e.a. perhaps set some specific deadline for ATHEROS_AR231X to be
submitted?

Thanks,


Paul Bolle

