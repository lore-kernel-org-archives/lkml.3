Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaCWPEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:04:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35216 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaCWPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <1395584848.57698.YahooMailNeo@web141603.mail.bf1.yahoo.com>
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>
	<1395228430.4896.6.camel@marge.simpson.net>
	<1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
	<CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
	<1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>
	<1395282203.11039.24.camel@marge.simpson.net>
	<1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com>
	<CAK2H+edMBcJhqe8=hQvCRYAm6GsqnoqwqU5By_FD6qMyoXvCjQ@mail.gmail.com>
	<1395584848.57698.YahooMailNeo@web141603.mail.bf1.yahoo.com>
Date: Sun, 23 Mar 2014 08:04:43 -0700
Message-ID: <CAK2H+ecHVBiGLh-065Ag17rUzYtkTxfF=xUHd7Xfpqx_gThtNQ@mail.gmail.com>
Subject: Re: Thread Scheduler
From: Mark Knecht <markknecht@gmail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 7:27 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>
>
>
>
> On Sunday, March 23, 2014 6:35 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>In terms of changing the scheduler I think that you possibly missed
>>reading Documentation/block/switching-sched.txt in the kernel's
>>documentation directory.
>>
>>HTH,
>>Mark
>
> That is IO scheduler. Can we use the same for threads/processes?
> echo deadline > /proc/10100
>
> Or something like that?
>
>
>
> Regards,
> Mahmood
>
Sorry, you're right. My mistake.

- Mark
