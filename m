Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3G3Rug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:50:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53580 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3G3Ruf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:50:35 -0400
Message-ID: <51F7FCE7.1040006@codeaurora.org>
Date: Tue, 30 Jul 2013 13:50:31 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Dave Martin <Dave.Martin@arm.com>, Robert Richter <rric@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jed Davis <jld@mozilla.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
 [OT]
References: <1373685501-1620-1-git-send-email-jld@mozilla.com> <20130715135420.GG10000@mudshark.cambridge.arm.com> <20130720044655.GC9433@mozilla.com> <20130721213753.GA29879@mudshark.cambridge.arm.com> <20130722185234.GA14519@localhost.localdomain> <20130729212140.GB12681@mozilla.com> <20130730092517.GB2478@localhost.localdomain> <20130730113853.46cbb00a@armhf> <20130730094457.GC2478@localhost.localdomain> <20130730120907.6dcc469e@armhf>
In-Reply-To: <20130730120907.6dcc469e@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 06:09 AM, Jean-Francois Moine wrote:
> On Tue, 30 Jul 2013 10:44:57 +0100
> Dave Martin <Dave.Martin@arm.com> wrote:
>> On Tue, Jul 30, 2013 at 11:38:53AM +0200, Jean-Francois Moine wrote:
>>> On Tue, 30 Jul 2013 10:25:18 +0100
>>> Dave Martin <Dave.Martin@arm.com> wrote:
>>>> The pragmatic route is less contraversial and lower overhead: even though
>>>> it's not correct as per the ABI, GCC is the only supported compiler for
>>>> building the kernel anyway.  

[...]

>>> Did anybody succeed with clang?  
>>
>> Hmm, I've no idea.  Is this possible?
> 
> freebsd kernels are compiled with clang, and I heard about linux
> patches, but I did not find them yet.

There's a project home page here:

http://llvm.linuxfoundation.org/index.php/Main_Page

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
