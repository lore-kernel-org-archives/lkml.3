Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaGQJCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:02:55 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:2908 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaGQJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:02:48 -0400
Message-ID: <53C7912A.4080404@imgtec.com>
Date: Thu, 17 Jul 2014 10:02:34 +0100
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, <ralf@linux-mips.org>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <m.szyprowski@samsung.com>
CC: <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86: use generic dma-contiguous.h
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1405525892-60383-4-git-send-email-Zubair.Kakakhel@imgtec.com> <xa1ta989b7ha.fsf@mina86.com>
In-Reply-To: <xa1ta989b7ha.fsf@mina86.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/07/14 17:20, Michal Nazarewicz wrote:
> On Wed, Jul 16 2014, Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
>> dma-contiguous.h is now in asm-generic. Use that to avoid code
>> repetition in x86.
>>
>> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> But to be honest, I would fold the three into a single commit.

Thank-you for the acks. I understand as its a trivial change.

But architectures like it separate. They will obviously go
together via one tree.

ZubairLK

