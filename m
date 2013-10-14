Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3JNP5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:57:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42878 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3JNP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:57:37 -0400
Message-ID: <525C1469.4000906@gmail.com>
Date: Mon, 14 Oct 2013 23:57:29 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Optimize jump label implementation on ARM64
References: <1381675827-1610-1-git-send-email-liuj97@gmail.com> <20131014154044.GR25034@n2100.arm.linux.org.uk>
In-Reply-To: <20131014154044.GR25034@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 11:40 PM, Russell King - ARM Linux wrote:
> On Sun, Oct 13, 2013 at 10:50:20PM +0800, Jiang Liu wrote:
>> To enable this feature, your toolchain must support "asm goto" extension
>> and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
>> "%c", so you need a GCC patch similiar to this:
> 
> Oh god, not that again.  I've no idea why ARM stuff has such a problem with
> supporting this very useful "%c" GCC constraint.  Aarch32 didn't for ages
> consequently we now have horrid hacks around it in the kernel source
> because our compilers suck.  Seems Aarch64 is doomed to repeat the same
> stupid mistakes. :(
> 
We need to do the same trick for ARM64 too:)
