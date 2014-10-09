Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaJITnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:43:08 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:53489 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaJITm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:42:59 -0400
In-Reply-To: <CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com>
References: <20141009190406.GA5428@localhost> <CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com> <CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: acpitool - /proc/acpi/wakeup
From: Marc Burkhardt <marc@osknowledge.org>
Reply-to: marc@osknowledge.org
Date: Thu, 09 Oct 2014 19:42:54 +0000
To: Frans Klaver <fransklaver@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <FC674684-FA28-47F3-BB5D-6709D2BFF770@osknowledge.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded from 3.10 on that machine. 3.12 didn't work for me due to a hibernation bug. The rest was left out...  :/

Thanks,
Marc

Am 9. Oktober 2014 21:31:52 MESZ, schrieb Frans Klaver <fransklaver@gmail.com>:
>On Thu, Oct 9, 2014 at 9:25 PM, Frans Klaver <fransklaver@gmail.com>
>wrote:
>> Hi,
>>
>> On Thu, Oct 9, 2014 at 9:04 PM, Marc Burkhardt <marc@osknowledge.org>
>wrote:
>>> Hi there,
>>> I noticed, that 'acpitool -e' doesn't work any longer sind I
>upgraded to 3.17.
>>> The tool stalls at
>>>
>>>    Device       S-state   Status   Sysfs node
>>>   ---------------------------------------
>>>   1. LID          S3    *enabled   platform:PNP0C0D:00
>>>   2. SLPB         S3    *enabled   platform:PNP0C0E:0
>>
>> I see the same thing.
>
>With which kernel version did it last work properly for you?

