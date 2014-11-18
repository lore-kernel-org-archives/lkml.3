Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaKRHUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:20:39 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64315 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaKRHUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:20:38 -0500
MIME-Version: 1.0
In-Reply-To: <1416207214.2826.3.camel@concordia>
References: <1415956325-10124-1-git-send-email-vvijayan@mvista.com> <1416207214.2826.3.camel@concordia>
From: Vineeth Vijayan <vvijayan@mvista.com>
Date: Tue, 18 Nov 2014 12:50:17 +0530
Message-ID: <CAOpNGcuL-0SDSwDbExLWqWxwp=0zRtRnx_MUnNEb9ywSFrhh8A@mail.gmail.com>
Subject: Re: [PATCH] [powerpc] Fix Text randomization
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:23 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Fri, 2014-11-14 at 14:42 +0530, Vineeth Vijayan wrote:
>> Now there is no way to disable TEXT randomization on a PPC32/PPC64
>> machine. Text randomization happens even in the case of "echo 0 >
>> /proc/sys/kernel/randomize_va_space"
>>
>> This happens due to the incorrect definition of ELF_ET_DYN_BASE
>> at arch/powerpc/include/asm/elf.h
>>
>> The function randomize_et_dyn is redundant and is removed.
>
> The patch looks OK, but for the change log I was thinking something more like
> this:
>
>
> powerpc: Use generic PIE randomization
>
Ok. Thats better.
Do you want me to send a new patch with updated change log as mentioned ?
