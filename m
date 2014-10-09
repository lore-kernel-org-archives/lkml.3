Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaJITcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:32:01 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47888 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaJITby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com>
References: <20141009190406.GA5428@localhost>
	<CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com>
Date: Thu, 9 Oct 2014 21:31:52 +0200
Message-ID: <CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com>
Subject: Re: acpitool - /proc/acpi/wakeup
From: Frans Klaver <fransklaver@gmail.com>
To: Marc Burkhardt <marc@osknowledge.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 9:25 PM, Frans Klaver <fransklaver@gmail.com> wrote:
> Hi,
>
> On Thu, Oct 9, 2014 at 9:04 PM, Marc Burkhardt <marc@osknowledge.org> wrote:
>> Hi there,
>> I noticed, that 'acpitool -e' doesn't work any longer sind I upgraded to 3.17.
>> The tool stalls at
>>
>>    Device       S-state   Status   Sysfs node
>>   ---------------------------------------
>>   1. LID          S3    *enabled   platform:PNP0C0D:00
>>   2. SLPB         S3    *enabled   platform:PNP0C0E:0
>
> I see the same thing.

With which kernel version did it last work properly for you?
