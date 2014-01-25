Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaAYRmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:42:16 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54927 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaAYRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:42:14 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21219.63346.161575.596495@gargle.gargle.HOWL>
Date: Sat, 25 Jan 2014 18:42:10 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <alpine.LRH.2.02.1401241232090.23466@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
	<21218.28095.779306.523187@gargle.gargle.HOWL>
	<alpine.LRH.2.02.1401241232090.23466@file01.intranet.prod.int.rdu2.redhat.com>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka writes:
 > 
 > 
 > On Fri, 24 Jan 2014, Mikael Pettersson wrote:
 > 
 > > Mikulas Patocka writes:
 > >  > Hi
 > >  > 
 > >  > Here I'm sending some ia64 patches to make it work in the ski emulator. 
 > >  > This has been broken for a long time.
 > > 
 > > Thanks.  I've recently started running 3.x kernels on ia64 via ski,
 > > but I'm getting random kernel crashes with 3.13.  I'll give your
 > > patches a try shortly.
 > 
 > BTW. does the kernel boot for you without that _STK_LIM_MAX change? For 
 > me, _STK_LIM_MAX was a showstopper, it wasn't able to spawn any userspace 
 > process without this patch.

Yes, everything works fine for me without your _STK_LIM_MAX change.
My ski VMs currently run 3.12 kernels with Fedora 9 user-space.

/Mikael
