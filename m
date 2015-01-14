Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbbANRza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:55:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39202 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbANRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:55:29 -0500
Message-ID: <54B6ADCF.1090403@ti.com>
Date: Wed, 14 Jan 2015 12:56:31 -0500
From: Vitaly Andrianov <vitalya@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <thomas.petazzoni@free-electrons.com>, <catalin.marinas@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [Resend PATCH] ARM: mm: use phys_addr_t in ioremap_page functions
References: <1421257452-18834-1-git-send-email-vitalya@ti.com> <20150114174407.GB12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150114174407.GB12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/14/2015 12:44 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 14, 2015 at 12:44:12PM -0500, Vitaly Andrianov wrote:
>> On a 32 bit ARM architecture with LPAE extension physical addresses
>> cannot fit into unsigned long variable.
>>
>> This patch fixes the ioremap_page function.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Acked-by: Murali Karicheri <m-karicheri2@ti.com>
>>
>> - Fixing the commit log and resending
>
> Still not happy.  Why do we even need this function which no one calls.
> Please delete it instead.
>

Thanks for the reply. I'll delete the function.
