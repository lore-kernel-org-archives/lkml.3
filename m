Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaIXA6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:58:42 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:64455 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaIXA6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:58:40 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:c074:25b1:7d97:a0af]
In-Reply-To: <20140923175137.aa87c1ea.akpm@linux-foundation.org>
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
 <5421EA22.6000206@infradead.org> <ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
 <CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com>
 <20140923163816.2f3cf938c7815424e55e444f@linux-foundation.org>
 <CAOFdcFMiqS6-QFUo-QbwroOMmXnUL5mJd=Pjei_RjT3mhO8P5g@mail.gmail.com> <20140923175137.aa87c1ea.akpm@linux-foundation.org>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 23 Sep 2014 20:58:19 -0400
Message-ID: <CAOFdcFOG0hfeUZz6QkjgfAYbsFN3uVHgSn25hWqwtd6bNU0d5A@mail.gmail.com>
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

On Tue, Sep 23, 2014 at 8:51 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Can't we just fix the Makefiles?  Cook up a rule which makes
> headers_install (if needed) before building Documentation/?

Currently, the ordering is enforced by
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Makefile#n946
I'll take a look at making Documentation/ depend on headers_install.

Thanks,

Peter
