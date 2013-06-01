Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3FAAQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:16:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56115 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3FAAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130530174727.GE3767@intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130530174727.GE3767@intel.com>
Date: Fri, 31 May 2013 17:09:51 -0700
X-Google-Sender-Auth: nvJfhTzc7hawBIDLSOMBmIeyFvQ
Message-ID: <CAA9_cmdNiLfJjv-8Mh-Xb1ifZb4aw_9NGCVW6aWsfq6BN-DYyQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] dma: various minor clean ups for slave drivers
From: Dan Williams <djbw@fb.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:47 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Mon, May 27, 2013 at 03:14:30PM +0300, Andy Shevchenko wrote:
>> Here is a set of small independent patches that clean up or fix minor things
>> across DMA slave drivers.
> The series looks fine. I am going to wait a day more and apply, pls speak up if
> you disagree and ack if you agree

Looks ok to me.  Reminds we can probably take this one step further
and provide a generic implementation for the common case.  It's just a
bit inconsistent though that some engines will poll the completion
handler (try to advance the state of the last completed cookie)
whereas others just assume things will be completed asynchronously.

--
Dan
