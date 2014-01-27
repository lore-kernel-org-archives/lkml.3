Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaA0Pvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:51:36 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64310 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaA0Pvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140123110346.GC2338@canopus.corp.1gb.ru>
References: <20140123110346.GC2338@canopus.corp.1gb.ru>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 27 Jan 2014 16:51:09 +0100
Message-ID: <CACQ1gAgK02y1=+yUc8kDcMb++QjGCmGQbNWskYke4=PPTHf6GA@mail.gmail.com>
Subject: Re: Unstable kernels work after 2.6.3x
To: Alexey Vlasov <renton@renton.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-23 Alexey Vlasov <renton@renton.name>:
> Hello,
>
> I've already written that after release of version 2.6.32 something
> strange happened either in the kernel or with its base features, namely
> since then there was not released even a single kernel, which would at
> least on my hosting work consistently and without bugs.
>
> That's the history of kernel crashes on one of my servers:
> 1.1 2013-02-14 22:47:01 - 3.7.3
> 1.2 2013-03-07 00:48:25 - 3.7.3
> 1.3 2013-03-07 13:59:45 - 3.7.3
> 1.4 2013-03-10 01:20 - 3.7.3
> 1.5 2013-03-14 00:47 - 3.8.2
> 1.6 2013-03-15 00:57 - 3.8.2
> 1.10 2013-03-17 04:00 - 3.8.2
> 1.14 2013-03-24 22:42 - 3.8.2
> 1.15 2013-03-25 01:30 - 3.8.2
> 1.16 2013-03-25 02:57 - 3.7.3
> 1.17 2013-04-02 06:09 - 3.8.4
> 1.18 2013-04-12 21:50 - 3.8.4
> 1.22 2013-06-02 20:12 - 3.8.4
> 1.23 2013-06-09 16:33 - 3.8.4
> 1.24 2013-07-28 02:00 - 3.9.4
> 1.25 2013-08-17 16:45 - 3.9.4
> 1.26 2013-09-03 21:07 - 3.10.10
> 1.27 2013-09-07 21:07 - 3.11.0
> 1.28 2013-09-15 06:18 - 3.11.0
> 1.29 2013-10-01 21:51 - 3.11.0
> 1.31 2013-10-11 22:02 - 3.11.4
> 1.34 2013-10-26 06:32 - 3.11.4
> 1.36 2013-11-05 06:26 - 3.11.4
> 1.37 2013-11-17 15:06 - 3.11.4
> 1.38 2013-12-07 08:29 - 3.9.11
> (date - kernel version)
>
> And this is a server with an old one:
> # uname -a
> Linux l7 2.6.25-r9-1gb-s #3 SMP Fri Nov 14 18:15:42 MSK 2008 x86_64
> Intel(R) Xeon(R) CPU E5430 @ 2.66GHz GenuineIntel GNU/Linux
> # uptime
>  13:29:40 up 731 days, 14:26,  5 users,  load average: 27.56, 18.75, 18.86
>
> Another:
> # uname -a
> Linux l5 2.6.25-r7-1gb #4 SMP Fri Aug 29 18:43:15 MSD 2008 x86_64
> Intel(R) Xeon(R) CPU E5345 @ 2.33GHz GenuineIntel GNU/Linux
> # uptime
>  13:31:48 up 733 days, 16:18,  5 users,  load average: 13.12, 10.79, 10.67
>
> And it's not just some trash standing in the closet, it's a highloaded
> server with several thousand websites and that also perform function of
> a gateway for VPS customers.
>
> I certainly can, in some way, understand all these hangings and
> failures, but it is difficult and sometimes impossible to explain them
> to our clients when they see their non-performing web-sites.
>
> Here's one of the latest of bugs:
> (3.12.3_kpanic.txt in attach)
>
> I'm completely satisfied with this kernel specifically, if I could
> somehow manage to fix this particular bug, it would be great. I don't
> want to try again to move to another new kernel, I've already had such an
> experience. If it is possible, can you just release a patch for
> particularly this kernel?
>
> Thank you in advance.
>
> --
> BRGDS. Alexey Vlasov.

[As almost nobody reads the LKML if he is not CCed directly, you may
want to CC a maintainer.]

as the kernel seems to crash around prepare_creds(), may be David
Howells can give you some thoughts.

Richard
