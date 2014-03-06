Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaCFKNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:13:09 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:56662 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaCFKNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:13:06 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] tile: Add support for handling PMC hardware
Thread-Topic: [PATCH 1/4] tile: Add support for handling PMC hardware
Thread-Index: Ac85AzzGirA9kpwRSmuKtpqeEoyE7gAQqrsAAAiNLKA=
Date: Thu, 6 Mar 2014 10:12:54 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FFC3@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF17@USMAExch1.tad.internal.tilera.com>
 <20140306091102.GG9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140306091102.GG9987@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Thursday, March 06, 2014 5:11 PM
>To: Tony Lu
>Cc: Paul Mackerras; Ingo Molnar; Arnaldo Carvalho de Melo; Chris Metcalf;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/4] tile: Add support for handling PMC hardware
>
>On Thu, Mar 06, 2014 at 06:13:48AM +0000, Tony Lu wrote:
>
>The changelogs are all very sparse. But in general the stuff looks to
>have the right shape.
>
>It looks like you do software NMIs with interrupt priority levels; which
>is a perfectly fine way, other archs do the same.
>
>One thing I didn't spot is a tile irq_work implementation; perf likes to
>have one.

We do not have tile irq_work for now. It seems like perf works fine even without the arch irq_work. Anyway, we will investigate it, and submit it as a separate patch when it gets ready.

Thanks
-Tony

