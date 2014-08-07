Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaHGPnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:43:01 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:46388 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaHGPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1408071131170.6061@knanqh.ubzr>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
	<1407353564-21478-2-git-send-email-keescook@chromium.org>
	<CAMo8Bf+uq1vhqb7KxnNFHTZ53C1mtw_Do6dn09j7jjw_7MWF_Q@mail.gmail.com>
	<CAL_JsqJgRFYTfdsY48C9QreBH=VcM3t-9AzFSV8oXLB5tVGjUw@mail.gmail.com>
	<alpine.LFD.2.11.1408071131170.6061@knanqh.ubzr>
Date: Thu, 7 Aug 2014 19:42:59 +0400
Message-ID: <CAMo8Bf+DP-xZGnnFFvwc1XDEGUGkj1KkYQ_x+2i_hE0a9t7NKw@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm: use generic fixmap.h
From: Max Filippov <jcmvbkbc@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Rob Herring <robh@kernel.org>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Salter <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 7:32 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 7 Aug 2014, Rob Herring wrote:
>
>> On Thu, Aug 7, 2014 at 10:15 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>> > Hi,
>> >
>> > On Wed, Aug 6, 2014 at 11:32 PM, Kees Cook <keescook@chromium.org> wrote:
>> >> ARM is different from other architectures in that fixmap pages are indexed
>> >> with a positive offset from FIXADDR_START.  Other architectures index with
>> >> a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
>> >
>> > Does anybody know if there's any reason why generic fixmap.h uses negative
>> > offsets? It complicates things with no obvious benefit if you e.g. try to align
>> > virtual address in the fixmap region with physical page color (that's why I've
>> > switched xtensa to positive fixmap addressing in v3.17).
>>
>> No, but each arch doing it differently is even more annoying.
>
> Why not switching everybody to positive offsets then?

I can cook a patch if people agree that that'd be good.

-- 
Thanks.
-- Max
