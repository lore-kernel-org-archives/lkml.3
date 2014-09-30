Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaI3N0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:26:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62213 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaI3N0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:26:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rik van Riel <riel@redhat.com>, atheurer@redhat.com, srao@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        umgwanakikbuti@gmail.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched, time: cmpxchg does not work on 64-bit variable
Date: Tue, 30 Sep 2014 15:26:06 +0200
Message-ID: <6045627.KStXj7ELPe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <542AA33E.2050008@redhat.com>
References: <2547036.UshV4pXvhf@wuerfel> <542AA33E.2050008@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cuiPoogGde+YT1aYZo2hlQyU+PCn4eeudeCY8oBck9Y
 kYHRVlT9evI1aaUCWq/oJ1qWCLdJn58DBmTLY6xbodiZn7aVJO
 42laS7zu5DT64dovdT8qm8U46soDWBBIJmMPiNxD4N6bnL32Fj
 SkDlgJltKuzIJM6gSIx1XMvzP5Hg7eSJAeEb0cUdWowAER8r/0
 bsUn47Gi8+08LBwf4gCdy4psoigrqcCkBX6xsLMmtIr/4SrXNQ
 KjkWzQ3nMoH4jC6t6L0poR1YF24IhzksS79DrenfgydX4xZuXA
 tvw2FGJP4Z9g2JShl3kMU61N+OISOAvxgFJ7zUTK+W6cUgai/K
 0aBNoNbtoakGlNfCO5LE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 08:34:06 Rik van Riel wrote:
> 
> Arnd, on which architecture are you seeing a build failure?
> Is it just 32 bit arm?
> 

Yes, I only tested on arm32, but I assume that most other 32-bit
architectures will behave in a similar way.

	Arnd
