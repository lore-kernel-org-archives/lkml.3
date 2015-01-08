Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbbAHRzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:55:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbbAHRzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:55:46 -0500
Message-ID: <54AEC470.50509@redhat.com>
Date: Thu, 08 Jan 2015 23:24:56 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "tixy@linaro.org" <tixy@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150108170324.GT11583@arm.com>
In-Reply-To: <20150108170324.GT11583@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 08 January 2015 10:33 PM, Will Deacon wrote:
> On Wed, Dec 31, 2014 at 03:21:24PM +0000, Pratyush Anand wrote:
>> This patch adds support for uprobe on ARM64 architecture.
>>
>> Unit test for following has been done so far and they have been found
>> working
>> 1. Normal instruction, which can be probed like sub, ldr, add etc.
>> 2. Instructions which can be simulated like ret.
>> 3. uretprobe
>
> I'm assuming that means you don't support compat (AArch32) tasks with this?

Hummm.. Yes, compat not yet supported.

I will come back on this.

~Pratyush

> How do you enforce that?
>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
