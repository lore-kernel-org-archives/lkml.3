Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaL3QAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:00:21 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52265 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL3QAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:00:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix arm64 platforms not booting
Date: Tue, 30 Dec 2014 16:59:36 +0100
Message-ID: <1497922.CDlllKVqB4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54A1BF89.70709@linaro.org>
References: <1419776431-26217-1-git-send-email-christoffer.dall@linaro.org> <20141229191357.GA21793@leverpostej> <54A1BF89.70709@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:F9W5rH2ZN+xy8Ph5q0tvJInniEGtC0GttVJl3XZbi7ToMgnrzBa
 965MGSBfxc4Q+qlFyjHHSXJgEPh9ctu0U5woxocYvXccyDvcJMI+7101Bo5QaUZoMH9/t6a
 BrmAZLSxp1dy7BMNzh+FjPQKfBq0aOhuHheu3emAsSNAnUW4rIqxaJZK80nGD88t5rxi5/3
 J73NBMLEVsXQa7s3mGPiA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2014 21:54:33 Daniel Lezcano wrote:
> On 12/29/2014 08:13 PM, Mark Rutland wrote:
> > On Mon, Dec 29, 2014 at 08:35:09AM +0000, Christoffer Dall wrote:
> >> On Sun, Dec 28, 2014 at 09:46:20PM +0000, Marc Zyngier wrote:
> >>> What is holding this patch which, as far as I remember, has been posted
> >>> by Catalin almost three weeks ago?
> >>>
> >> I didn't find that since I didn't think I'd have to go back that long on
> >> lakml for something that breaks boot of an entire architecture.  Sorry
> >> for the confusion of a second patch, but fwiw, I now spent another few
> >> hours bisecting this, so I would really like to see this fix go into
> >> mainline ASAP as well to save others the trouble.
> >
> > Last I knew, Arnd was going to take the fix [1], which has been in
> > arm-soc's for-next and fixes branches for almost two weeks now. It
> > didn't make it into the last pull req due to some confusion over who was
> > going to take it.
> 
> I asked arm-soc team to take the fix because it was depending on a patch 
> which was already in their tree [1].

Sorry for dropping the ball on this, I've send out a pull request to Linus
now.

	Arnd
