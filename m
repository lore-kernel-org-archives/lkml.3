Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751Ab3DKCkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:40:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41867 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3DKCkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:40:36 -0400
Message-ID: <5166229D.2090904@gmail.com>
Date: Thu, 11 Apr 2013 10:40:29 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com> <515CD359.40004@gmail.com> <515CD3BF.5010104@zytor.com>
In-Reply-To: <515CD3BF.5010104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H.Peter,
On 04/04/2013 09:13 AM, H. Peter Anvin wrote:
> On 04/03/2013 06:11 PM, Simon Jeons wrote:
>> Why we consider boot_cpu_data.x86_phys_bits instead of e820 map here?
>>
> Because x86_phys_bits is what controls how much address space the
> processor has.  e820 tells us how much *RAM* the machine has, or
> specifically, how much RAM the machine had on boot.

I have 8GB memory in my machine, but when I accumulated every e820 
ranges which dump in dmesg, there are 25MB memory less then 8GB(1024*8) 
memory, why 25MB miss?

>
> 	-hpa
>

