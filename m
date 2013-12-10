Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3LJIad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:30:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:9437 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3LJIaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:30:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="441548422"
Date: Tue, 10 Dec 2013 09:29:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: micky <micky_ching@realsil.com.cn>
Cc: wwang <wei_wang@realsil.com.cn>, Francis Moreau <francis.moro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131210082955.GG8612@zurbaran>
References: <1821758.2MoNI3h1Mv@vostro.rjw.lan>
 <52985041.5050000@gmail.com>
 <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
 <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
 <529D92D6.8050409@gmail.com>
 <20131209221721.GB8612@zurbaran>
 <52A670E4.5050501@realsil.com.cn>
 <52A674E0.2080407@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A674E0.2080407@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micky,

On Tue, Dec 10, 2013 at 09:56:48AM +0800, micky wrote:
> Hi Francis:
> On 12/10/2013 09:39 AM, wwang wrote:
> >which is based on Thomas' patch.
> 
> Can you help us test this patch, we disable irq while suspend here.
I already pushed a patch from Thomas to mfd-fixes that seems to fix the
resume breakage:

https://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-fixes.git/commit/?id=19e49e445e198197c5e243f92d333d076e23d032

Cheers,
Samuel.

--
Intel Open Source Technology Centre
http://oss.intel.com/
