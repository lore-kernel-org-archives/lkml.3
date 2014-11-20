Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaKTFKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:10:11 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48640 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKTFKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <546CAF5A.4060901@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	<1416292375-29560-2-git-send-email-dave.long@linaro.org>
	<20141118145643.GO18842@arm.com>
	<CA+b37P337jcTCPTg4Ydxh6TKwqmyMngt-eEowzfsTNBDZ7-NEg@mail.gmail.com>
	<20141119112553.GC15985@arm.com>
	<546CAF5A.4060901@linaro.org>
Date: Thu, 20 Nov 2014 10:40:08 +0530
Message-ID: <CA+b37P1UGDvVsCr_Y5p+N3MZF6fb-w09hb2woHmuy2ZDO84aWg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2014 20:25, David Long <dave.long@linaro.org> wrote:
>> I was thinking of the magic hex numbers in the kprobes decode tables,
>> which
>> seem to correspond directly to the instruction classes described in insn.c
>>
>> Keeping the actual emulation code separate makes sense.
>>
>> Will
>
>
> Of course that follows the model of the much more complex arm32
> kprobes/uprobes decoding.  I can have a go at replacing it with insn.c
> calls.
well, the magic hex numbers were derived directly from ARMv8 ARM
Tabled C4.1 thru C4.6 and bit-masking would be faster search, but
surely you can give a try with insn.c (this would consume lot of
function calls to arrive at same decision).
~Sandeepa
>
> -dl
>
