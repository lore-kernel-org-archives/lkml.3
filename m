Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbbAMPY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:57 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57895 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbbAMPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sirf: remove unused variable
Date: Tue, 13 Jan 2015 16:24:08 +0100
Message-ID: <22227544.6odKQXu0TN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54B52B39.1000607@linaro.org>
References: <1599190.ZYSE4SrQSK@wuerfel> <54B52B39.1000607@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:8T09sslYYREXkewyd7LRqWJx/W7GLoFksBa3nk74uAmJhyjiO1R
 V2e/0rhCt3GII4U+3/KcunnPEcPbj/+Ptid555VumO5TSx8GDr8C6MXtTt4Qihu88d/jmym
 SjFkzGKPDkh6/v7q8gIUvuxvdIbK/7pLnSFXgPFSuFU7K7iiiA/q6peUxQHkp02GEitQtne
 ZxKa30x+bt6ei5BBlF84Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 15:27:05 Daniel Lezcano wrote:
> On 01/13/2015 03:22 PM, Arnd Bergmann wrote:
> > A recent rework of the driver left an obviously unused variable
> > around, and now the compiler complains:
> >
> > clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
> > clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]
> >
> > Remove it.
> 
> Hi Arnd,
> 
> thanks for the fix. But this has been already fixed and merged in my 
> tree [1].

Ok, thanks. For some reason it has not shown up in Linux-next yet.
Is this branch supposed to be part of -next?

	Arnd
