Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaAVKb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:31:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56455 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaAVKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:31:56 -0500
Message-ID: <52DF9E04.9030404@zytor.com>
Date: Wed, 22 Jan 2014 02:31:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Liu, Jinsong" <jinsong.liu@intel.com>,
        "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: Re: [PATCH v3 1/4] KVM/X86: Fix xsave cpuid exposing bug
References: <DE8DF0795D48FD4CA783C40EC82923350149E30B@SHSMSX101.ccr.corp.intel.com> <52DF9BBE.1040802@redhat.com>
In-Reply-To: <52DF9BBE.1040802@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 02:21 AM, Paolo Bonzini wrote:
> Il 21/01/2014 19:59, Liu, Jinsong ha scritto:
>> From 3155a190ce6ebb213e6c724240f4e6620ba67a9d Mon Sep 17 00:00:00 2001
>> From: Liu Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 13 Dec 2013 02:32:03 +0800
>> Subject: [PATCH v3 1/4] KVM/X86: Fix xsave cpuid exposing bug
>>
>> EBX of cpuid(0xD, 0) is dynamic per XCR0 features enable/disable.
>> Bit 63 of XCR0 is reserved for future expansion.
>>
>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> 
> Peter, can I have your acked-by on this?
> 

Yes.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

