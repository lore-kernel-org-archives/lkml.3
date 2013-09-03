Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3ICHfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:35:36 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62668 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3ICHfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:35:34 -0400
Message-ID: <5225914D.5050305@googlemail.com>
Date: Tue, 03 Sep 2013 08:35:41 +0100
From: Chris Clayton <chris2553@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Chris Clayton <chris2553@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: Networking problem with 3.11-rc6+
References: <5213CB17.5050308@googlemail.com> <20130820215419.GA29560@electric-eye.fr.zoreil.com>
In-Reply-To: <20130820215419.GA29560@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/20/13 22:54, Francois Romieu wrote:
> Chris Clayton <chris2553@gmail.com> :
> [...]
>> [    0.207094] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [    0.207155] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [...]
>> [    5.311191] r8169 0000:07:00.0: can't disable ASPM; OS doesn't have ASPM control
> [...]
>> [   65.181715] [<f8e38000>] rtl8169_interrupt [r8169]
>> [   65.181717] Disabling IRQ #17
>>
>> Let me know if I can provide any additional information, although to
>> be honest, the boot completed and the KDE desktop started up OK, so
>> there may not be much else I can provide unless I find that the
>> problem is repeatable.
>
> Please don't hesitate if it happens again, even if it can't be reproduced
> on demand.
>

I've booted the kernel numerous times since the incident reported above, 
but haven't encountered the problem again. If it does happen again, are 
there any files from /sys or /proc that might help diagnostics?

Chris
