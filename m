Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbaIWXrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:47:35 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:35791 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:47:33 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:c074:25b1:7d97:a0af]
In-Reply-To: <20140923163816.2f3cf938c7815424e55e444f@linux-foundation.org>
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
 <5421EA22.6000206@infradead.org> <ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
 <CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com> <20140923163816.2f3cf938c7815424e55e444f@linux-foundation.org>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 23 Sep 2014 19:47:11 -0400
Message-ID: <CAOFdcFMiqS6-QFUo-QbwroOMmXnUL5mJd=Pjei_RjT3mhO8P5g@mail.gmail.com>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd
 builds for kernels < 3.13
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ashutosh dixit <ashutosh.dixit@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 7:38 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> This build error is caused by compiling mpssd prior to `make
> headers_install'.
>
> There's really no reason to check the kernel version.  If someone
> transplants mpssd out of its distributed kernel and into some older
> kernel then a miscompile is their problem - their backport is
> incomplete.

I've only noticed this error when running make Documentation/,
in which case gcc silently uses the headers from the system,
since the headers_install ones don't exist yet.

Maybe having the build error out in this case instead of having mysterious
compile errors would be a better solution?

Thanks

Peter
