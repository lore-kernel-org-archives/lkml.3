Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaATXAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:00:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:31073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaATXAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,692,1384329600"; 
   d="scan'208";a="469772746"
Message-ID: <52DDAA87.40804@linux.intel.com>
Date: Mon, 20 Jan 2014 15:00:23 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
In-Reply-To: <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 02:54 PM, Linus Torvalds wrote:
> So I pulled this, but one question:
> 
> On Mon, Jan 20, 2014 at 8:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> +config RANDOMIZE_BASE
>> +       bool "Randomize the address of the kernel image"
>> +       depends on RELOCATABLE
>> +       depends on !HIBERNATION
> 
> How fundamental is that "!HIBERNATION" issue? Right now that
> anti-dependency on hibernation support will mean that no distro kernel
> will actually use the kernel address space randomization. Which
> long-term is a problem.
> 
> I'm not sure HIBERNATION is really getting all that much use, but I
> suspect distros would still want to support it.
> 
> Is it just a temporary "I wasn't able to make it work, need to get
> some PM people involved", or is it something really fundamental?
> 

Kees, could you comment?

	-hpa


