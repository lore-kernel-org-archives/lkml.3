Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaHAKUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:20:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39866 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHAKUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:20:30 -0400
Message-ID: <53DB6A18.5050904@arm.com>
Date: Fri, 01 Aug 2014 11:21:12 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [Query] How to pass reboot arguments to secure firmware with
 PSCI spec
References: <20140801180652.72e722be@xhacker>
In-Reply-To: <20140801180652.72e722be@xhacker>
X-OriginalArrivalTime: 01 Aug 2014 10:20:28.0299 (UTC) FILETIME=[37515DB0:01CFAD72]
X-MC-Unique: 114080111202802001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/08/14 11:06, Jisheng Zhang wrote:
> Hi Catalin and Will,
>
> I noticed that the following commit implement reboot via. PSCI SYSTEM_RESET
> function. So my question is how to handle the reboot arguments?
>

What reboot arguments do you want to handle ?

>
>> static void psci_sys_reset(enum reboot_mode reboot_mode, const char *cmd)
>> {
>>        invoke_psci_fn(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);
>
> How to pass cmd to secure firmware?
>

What cmd do you want to pass ? The function id is already handled. What
else do you want to pass ?

If you see PSCI v0.2 spec, the SYSTEM_RESET and SYSTEM_SHUTDOWN takes no
parameters.

Regards,
Sudeep

