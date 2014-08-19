Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaHSIMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:12:38 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34820 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHSIMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:12:36 -0400
Message-ID: <53F306E7.8020701@gmail.com>
Date: Tue, 19 Aug 2014 16:12:23 +0800
From: Peng Fan <van.freenix@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Do not overwrite __machine_arch_type
References: <1408418491-29330-1-git-send-email-van.freenix@gmail.com> <20140819074344.GA30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140819074344.GA30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/19/2014 03:43 PM, Russell King - ARM Linux wrote:
> On Tue, Aug 19, 2014 at 11:21:31AM +0800, Peng Fan wrote:
>> If using DT_MACHINE_START when enabled CONFIG_OF, the nr of mdesc is ~0.
>> The value of __machine_arch_type is passsed from bootloader using reigster
>> r1, and assigned in head-common.S. Remove this line to avoid overwrite it.
> 
> No.  The idea here is that the machine_is_xxx() methods are not used when
> using DT, so this disables them.
> 
Got it. Thanks.

Regards,
Peng.
