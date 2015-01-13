Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbbAMQXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:23:41 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:58192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbbAMQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:23:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Barry Song <21cnbao@gmail.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Yanchang Li <yl22@csr.com>, LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <Baohua.Song@csr.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sirf: remove unused variable
Date: Tue, 13 Jan 2015 17:22:55 +0100
Message-ID: <8635006.m811OQopQd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGsJ_4xgF5y9GQ2roh1MYSrvm+_n+fyxsUiVCp4gm+igTbdWdQ@mail.gmail.com>
References: <1599190.ZYSE4SrQSK@wuerfel> <54B52B39.1000607@linaro.org> <CAGsJ_4xgF5y9GQ2roh1MYSrvm+_n+fyxsUiVCp4gm+igTbdWdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Y+J9MT2aUPSXmGyyr+Xe4KQo7l3UQn3Tp0jcwLHWwmyZRCmfxko
 FLVFiccV5Im9Begp8cPkY863+GMUHBUks6cdLzf9EZEK5tC+Ql2+YRARyZ2AN7XH3WhFZSD
 IVdB28g1BRRRHUHW5QV4PRUL3sTfMigsPUCYQ9hoV8MRsrLpkixWNEN7F1pjjX65879nXM6
 8Vypiv+0RA7QdOfvqQxxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 23:24:24 Barry Song wrote:
> 
> yes, arnd. i also asked Daniel to apply "clocksource: marco: Rename
> marco to atlas7" rebased on this fix here:
> https://git.linaro.org/people/daniel.lezcano/linux.git/commit/81428bbe1d8a073bb3741678ef1d3c1016119c77

Ok
 
> so this one is excluded from my pull request for atlas7. a
> pull-request from arm-soc might cause merge conflicts?

I was just doing build-tests on linux-next today and submitted patches
for each new warning or error I saw. Nothing to worry about as it's already
fixed and I'm dropping my version as soon as the other fix makes it into
next.

	Arnd
