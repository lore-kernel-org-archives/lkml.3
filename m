Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCBUsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:48:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55271 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaCBUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:48:03 -0500
Message-ID: <531398FC.6020405@gmail.com>
Date: Sun, 02 Mar 2014 21:47:56 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] phy: mvebu-sata: prepare new Dove DT Kconfig variable
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com> <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com> <5311E2EB.70301@ti.com>
In-Reply-To: <5311E2EB.70301@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 02:38 PM, Kishon Vijay Abraham I wrote:
> On Saturday 01 March 2014 02:03 PM, Sebastian Hesselbarth wrote:
>> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to
>> MACH_DOVE in
>> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
>> DT-only MACH_DOVE Kconfig.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Kishon,
>>
>> Mark Brown requested to take the corresponding ASoC patch through
>> his tree. Therefore, I have split the former patch into individual
>> subsystem
>> patches. This patch also received an update, to not break bisectability
>> we add DT-enabled MACH_DOVE and maintain ARCH_DOVE, which is non-DT only
>> after conversion. ARCH_DOVE will be removed, when legacy mach-dove will
>> be removed.
>
> Cool.. Should this patch be going through PHY tree?

Yes, please pick it up.

Thanks,
   Sebastian

