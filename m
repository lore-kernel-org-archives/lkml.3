Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3H1Kx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:53:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55210 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3H1Kxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:53:54 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-ce-521dd6c07492
Message-id: <521DD6BD.4030700@samsung.com>
Date: Wed, 28 Aug 2013 13:53:49 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: linux-next: Tree for Aug 28 [ xhci build breakage ]
References: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
 <CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
 <CA+icZUVTzMxS4f3kZnauDkrpf4vwMbS3zd7ECOhE37S_FF83UA@mail.gmail.com>
 <CA+icZUVsG-1J2oYF+AeHsxonG2ABW4d0464yijNwaq7R5k94SQ@mail.gmail.com>
 <521DD43D.7070605@samsung.com>
 <CA+icZUWQp0k8jMqY=_DYW2Ev1cEhpev=iQNnc=NbHNgHNbifTA@mail.gmail.com>
In-reply-to: <CA+icZUWQp0k8jMqY=_DYW2Ev1cEhpev=iQNnc=NbHNgHNbifTA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xa7oHrskGGfxdamjRvHg9m8XlXXPY
	LA4ubGO0WLSsldmi+cQpZot1U0+wWGzde5Xdgd2j8cYNNo+ds+6ye8w7Geixf+4ado/Pm+QC
	WKO4bFJSczLLUov07RK4Mm6+P8ZecF+p4uTti2wNjPtkuxg5OSQETCQ+ff7GDmGLSVy4t54N
	xBYSWMoosfStfhcjF5DdyCSx5nwzI0RiLqPEjVm+IDavgJZEb/9WVhCbRUBV4vO6+WDNbAJ6
	Ehuaf4ANFRWIkFi55AErRL2gxI/J91hAbBEBSYl3318wgyxgFvjBKPH98XWwImEBB4kJjx6w
	Q2zuZ5aYf3cG2FROgWCJJ38ngtnMAuoSk+YtYoaw5SU2r3nLDHGdqkT32rVsEO8oSpyefI55
	AqPwLCTLZyFpn4WkfQEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkHj5soNx8TGrQ4wC
	HIxKPLwWm2WChFgTy4orcw8xSnAwK4nw8m+XDRLiTUmsrEotyo8vKs1JLT7EyMTBKdXA2H6m
	77DK+RpF/Q8X/Av1zF7V1TjduPz24V3TdLMkNrYLBm+4NWYU5IjtnRa+xGn1ls72WIkFf+6f
	EKrd/uNkqXRcwmmlppRFiulGRYmFcaZd7O8vdQYFr1W+f0SAMe/TWuZGts0fZvb4LHtwVmTd
	EmXXO9tb2t7o+G/2vmrrfzYr/F/ClUcaSizFGYmGWsxFxYkAuGAufXUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/13 13:46, Sedat Dilek wrote:
> On Wed, Aug 28, 2013 at 12:43 PM, Dmitry Kasatkin
> <d.kasatkin@samsung.com> wrote:
>> On 28/08/13 13:38, Sedat Dilek wrote:
>>> On Wed, Aug 28, 2013 at 12:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> On Wed, Aug 28, 2013 at 11:56 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> On Wed, Aug 28, 2013 at 11:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> Changes since 20130827:
>>>>>>
>>>>>> The f2fs tree lost its build failure.
>>>>>>
>>>>>> The md tree gained a conflict against the arm tree.
>>>>>>
>>>>>> The libata tree lost its build failure.
>>>>>>
>>>>>> The spi tree lost its build failure.
>>>>>>
>>>>>> The arm-soc tree gained conflicts against the usb tree.
>>>>>>
>>>>>> The dma-mapping tree gained a conflict against the driver-core tree.
>>>>>>
>>>>>> The akpm-current tree gained a conflict against the net tree.
>>>>>>
>>>>>> ----------------------------------------------------------------------------
>>>>>>
>>>>>> My build here breaks like this:
>>>>>>
>>>>>>   CC      drivers/usb/host/xhci-ring.o
>>>>>>   CC      drivers/video/console/softcursor.o
>>>>>> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_intr_tx':
>>>>>> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
>>>>>> function 'DEFINE_DYNAMIC_DEBUG_METADATA'
>>>>>> [-Werror=implicit-function-declaration]
>>>>>> drivers/usb/host/xhci-ring.c:3090:3: error: 'descriptor' undeclared
>>>>>> (first use in this function)
>>>>>> drivers/usb/host/xhci-ring.c:3090:3: note: each undeclared identifier
>>>>>> is reported only once for each function it appears in
>>>>>> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
>>>>>> function '__dynamic_pr_debug' [-Werror=implicit-function-declaration]
>>>>>> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_isoc_tx_prepare':
>>>>>> drivers/usb/host/xhci-ring.c:3875:3: error: 'descriptor' undeclared
>>>>>> (first use in this function)
>>>>>> cc1: some warnings being treated as errors
>>>>>> make[5]: *** [drivers/usb/host/xhci-ring.o] Error 1
>>>>>> make[4]: *** [drivers/usb/host] Error 2
>>>>>>
>>>>>> My kernel-config is attached.
>>>>>>
>>>>> Looks like <linux/device.h> or <linux/dynamic_debug.h> is missing.
>>>>>
>>>>> $ egrep -w '__dynamic_pr_debug|DEFINE_DYNAMIC_DEBUG_METADATA' -nr linux/include/
>>>>> linux/include/linux/device.h:1118:
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);                 \
>>>>> linux/include/linux/device.h:1121:
>>>>> __dynamic_pr_debug(&descriptor, pr_fmt(fmt),            \
>>>>> linux/include/linux/dynamic_debug.h:45:int __dynamic_pr_debug(struct
>>>>> _ddebug *descriptor, const char *fmt, ...);
>>>>> linux/include/linux/dynamic_debug.h:63:#define
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)         \
>>>>> linux/include/linux/dynamic_debug.h:76:
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
>>>>> linux/include/linux/dynamic_debug.h:78:
>>>>> __dynamic_pr_debug(&descriptor, pr_fmt(fmt),    \
>>>>> linux/include/linux/dynamic_debug.h:84:
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
>>>>> linux/include/linux/dynamic_debug.h:92:
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
>>>>> linux/include/linux/dynamic_debug.h:101:
>>>>> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,               \
>>>>>
>>>>> Can't say which one is preferred here.
>>>>>
>>>> looks like device.h is preferred or used in the sources, but this does
>>>> not fix the issue here.
>>>> sth. wrong with dev_dbg_ratelimited()?
>>>>
>>> That change seems to cause the problems:
>>>
>>> commit 0730d52a86919300a39a2be37f6c140997dfb82f
>>> "xhci:prevent "callbacks suppressed" when debug is not enabled"
>>>
>>> - Sedat -
>>>
>>> [1] http://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/xhci-ring.c?h=usb-next&id=0730d52a86919300a39a2be37f6c140997dfb82f
>>>
>> Hello,
>>
>> [PATCHv2 1/2] was not applied before.
>> I pointed this out few hours ago...
>>
>> - Dmitry
>>
> Yupp, just read it a few seconds ago.
>
> Where is that whatever 2nd fix?
>
> - Sedat -
>
> [1] http://marc.info/?l=linux-usb&m=137767590629869&w=2
>

1/2 - was not applied
https://patchwork.kernel.org/patch/2850217/

2/2 - this one was applied
https://patchwork.kernel.org/patch/2850218/

- Dmitry

