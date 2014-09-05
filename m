Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaIEKLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:11:01 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55099 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909AbaIEKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:10:59 -0400
Message-ID: <1409911856.7832.9.camel@x220>
Subject: Re: [PATCH 09/28] Remove ATHEROS_AR231X
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Richard Weinberger <richard@nod.at>,
        Jonathan Bither <jonbither@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, ath5k-devel@venema.h4ckr.net,
        open@hauke-m.de, list@hauke-m.de, antonynpavlov@gmail.com,
        openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 12:10:56 +0200
In-Reply-To: <1403091974.1984.102.camel@x220>
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
	 <1403091974.1984.102.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 10:10:56.0892 (UTC) FILETIME=[AF30D3C0:01CFC8F1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri, Nick, Luis, John,

On Wed, 2014-06-18 at 13:46 +0200, Paul Bolle wrote:
> Having this conversation every rc1 is getting a bit silly. Could Jiri
> e.a. perhaps set some specific deadline for ATHEROS_AR231X to be
> submitted?

I waited until rc3. Have you seen any activity on this front? If not,
should I resend the patch that removes the code in mainline that depends
on ATHEROS_AR231X (ie, AHB bus support)?

And to repeat the obvious: the removed code can always be re-added once
ATHEROS_AR231X gets actually added to the tree.

Thanks,


Paul Bolle

