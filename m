Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3GJFjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:39:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:53894 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3GJFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:39:11 -0400
Message-ID: <51DCF3A1.6050101@windriver.com>
Date: Wed, 10 Jul 2013 13:39:45 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e with
 __end_interrupts
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com> <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com> <6A3DF150A5B70D4F9B66A25E3F7C888D070AE11F@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D070AE11F@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:17 PM, Bhushan Bharat-R65777 wrote:
>
>
>> -----Original Message-----
>> From: Linuxppc-dev [mailto:linuxppc-dev-
>> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
>> Sent: Tuesday, July 09, 2013 1:33 PM
>> To: benh@kernel.crashing.org
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Subject: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e with
>> __end_interrupts
>>
>> We can rename 'interrupt_end_book3e' with '__end_interrupts' then book3s/book3e
>> can share this unique label to make sure we can use this conveniently.
>
> I think we can be consistent with start and end names, no?

Are you saying to rename 'interrupt_base_book3e' with '__base_interrupts' here? 
But seems optional since book3s have no this similar start label, so I'd like to 
keep that as original now.

Lets listen other comments firstly.

Tiejun

