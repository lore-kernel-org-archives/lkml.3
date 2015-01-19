Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbbASP2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:28:16 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52519 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbASP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:28:14 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20150119122310.GA27065@rei>
References: <20150119122310.GA27065@rei>
Date: Mon, 19 Jan 2015 16:28:13 +0100
Message-ID: <CA+icZUV53AWik-bS4a3DwgExD26nhCWxJWb-kGN_nAOWsikuLA@mail.gmail.com>
Subject: Re: [LTP] The Linux Test Project has been released for JANUARY 2015
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp-list@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
        libc-alpha@sourceware.org, lwn@lwn.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 1:23 PM, Cyril Hrubis <chrubis@suse.cz> wrote:
> God news everyone,
>
> the Linux Test Project test suite stable release for *January 2015* has
> been released.
>
> Since the last release 139 patches by 21 authors were merged.
>
> Notable changes are:
>
> * Fixes and enhancements of network testcases by Alexey Kodanev
>
> * New testcases for mount, network and ipc namespaces by Matus Marhefka
>
> * New testcase for fanotify ignore masks
>
> * New policy and library helpers to install and access testcase datafailes
>
> * Use of coccinelle and spatch to fix bugs and cleanup old code
>
> * And many more smaller fixes and enhancements
>
>
> If you are not familiar with LTP there is a nice article at LWN.net
> https://lwn.net/Articles/625969/.
>
> The latest version of the test-suite contains 3000+ tests for the Linux
> and can be downloaded at:
>
> http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20150119/
>

Hi,

congrats to the new release!

I will check my "iniza" setup of Linux v3.19-rc5 the "(runltp-)lite" way.

Can you please add checksum files (md5sum, sha256, etc.) to the place
where we get the tarballs, please?

Thanks.

Regards,
- Sedat -

> The project pages as well as GIT repository are hosted on GitHub for
> quite some time now:
>
> https://github.com/linux-test-project/ltp
> http://linux-test-project.github.io/
>
> If you ever wondered how to write a LTP testcase, don't miss our developer
> documentation at:
>
> https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
> https://github.com/linux-test-project/ltp/wiki/BuildSystem
>
> Patches, new tests, bugs, comments or questions should go to
> to our mailing list at ltp-list@lists.sourceforge.net.
>
> --
> Cyril Hrubis
> chrubis@suse.cz
>
> ------------------------------------------------------------------------------
> New Year. New Location. New Benefits. New Data Center in Ashburn, VA.
> GigeNET is offering a free month of service with a new server in Ashburn.
> Choose from 2 high performing configs, both with 100TB of bandwidth.
> Higher redundancy.Lower latency.Increased capacity.Completely compliant.
> http://p.sf.net/sfu/gigenet
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list
