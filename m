Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaIWWAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:00:12 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52934 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIWWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:00:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:c074:25b1:7d97:a0af]
In-Reply-To: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 23 Sep 2014 17:59:48 -0400
Message-ID: <CAOFdcFOdnyFCf-afZaO8ZS2fvC=-V=nhb1WonOa6AwmjxSgwgg@mail.gmail.com>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd
 builds for kernels < 3.13
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 5:55 PM, Ashutosh Dixit
<ashutosh.dixit@intel.com> wrote:
> mpssd depends on headers available in kernels >= 3.13. Therefore
> disable the build for kernels < 3.13. For kernels < 3.13, to avoid the
> appearance of a build break simply print an error message and exit.
>
Everything in Documentation should be built against the headers in the
kernel source tree due to the dep on CONFIG_HEADERS_CHECK.
The patch that added this code was in the 3.12 tree
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Makefile?id=8d49751),
did it not work when it was first merged?
What was the exact command you used to compile this code?
Did you make sure check_headers was run first?

Thanks,

Peter
