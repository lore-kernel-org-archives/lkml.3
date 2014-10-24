Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaJXKe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:34:56 -0400
Received: from service88.mimecast.com ([195.130.217.12]:33658 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXKez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:34:55 -0400
Message-ID: <544A2B4B.3050207@arm.com>
Date: Fri, 24 Oct 2014 11:34:51 +0100
From: Andre Przywara <andre.przywara@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Z Lim <zlim.lnx@gmail.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BPF crash with 3.18-rc1 on arm64 Juno hardware
References: <54493433.4090703@arm.com> <CABg9mcu0-AFNNOn+C4kbS7_rWqc-6WXZTyKUJYz6rA7-8OBqZA@mail.gmail.com> <20141024103158.GB1955@localhost>
In-Reply-To: <20141024103158.GB1955@localhost>
X-MC-Unique: 114102411345200702
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/10/14 11:31, Catalin Marinas wrote:
> On Thu, Oct 23, 2014 at 06:23:49PM +0100, Z Lim wrote:
>> On Thu, Oct 23, 2014 at 10:00 AM, Andre Przywara <andre.przywara@arm.com> wrote:
>>> I see a crash with 3.18-rc1 on a Juno board related to bpf_jit (see dump
>>> below). Userland tries to carry on afterwards, but eventually hangs in
>>> RCU stalls.
>>> The kernel has just CONFIG_BPF_JIT enabled, I guess Ubuntu enables this
>>> automatically if detected.
>>
>> When net-next and arm64-next merged in mainline, a silent failure is
>> introduced due to new enhancements in net/bpf.
>> This was actually uncovered before 3.18 merge window, and Daniel's
>> patch to fix this was discussed here [1].
>> I see that Catalin has queued up this patch in fixes/core [2].
>
> Indeed. Pull request to Linus will go out later today.

Indeed this patch fixes it for me.
Thanks to both of you!

Cheers,
Andre.

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

