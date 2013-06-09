Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3FIW6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:58:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55078 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3FIW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:58:01 -0400
Message-ID: <51B50873.8010104@gmail.com>
Date: Sun, 09 Jun 2013 15:57:55 -0700
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v5 5/6] mips/kvm: Fix ABI by moving manipulation of CP0
 registers to KVM_{G,S}ET_ONE_REG
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com> <1369248236-27237-6-git-send-email-ddaney.cavm@gmail.com> <20130608110503.GF15299@redhat.com>
In-Reply-To: <20130608110503.GF15299@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 04:05 AM, Gleb Natapov wrote:
> On Wed, May 22, 2013 at 11:43:55AM -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Because not all 256 CP0 registers are ever implemented, we need a
>> different method of manipulating them.  Use the
>> KVM_SET_ONE_REG/KVM_GET_ONE_REG mechanism.
>>
>> Now unused code and definitions are removed.
>>
> Just noticed that KVM_REG_MIPS_ definitions are wrong. You need to
> define KVM_REG_MIPS in include/uapi/linux/kvm.h (please use
> 0x7000000000000000ULL as 0x6000000000000000ULL is reserved for ARM64)
> and define all KVM_REG_MIPS_ values as "KVM_REG_MIPS | value". Can you
> send a patch to do that ASAP?

It will have to be tomorrow, I cannot test anything today.

Thanks,
David Daney

