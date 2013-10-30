Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3J3GMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:12:06 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56221 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3J3GMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:12:03 -0400
Message-ID: <5270A32F.5030909@linux.com>
Date: Wed, 30 Oct 2013 07:11:59 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Len Brown <lenb@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
        Aaron Lu <aaron.lu@intel.com>, ACPI List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] ACPI: Add Toshiba NB100 to Vista _OSI blacklist
References: <526FE7E8.80806@linux.com> <2710175.xeuRHdVpyL@vostro.rjw.lan>
In-Reply-To: <2710175.xeuRHdVpyL@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-29 23:44 keltezéssel, Rafael J. Wysocki írta:
> On Tuesday, October 29, 2013 05:52:56 PM Levente Kurusa wrote:
>> This patch adds Toshiba NB100 to the Vista _OSI blacklist.
>>
>> The _OSI(Windows 2006) method is bugged on the netbook resulting in messed up
>> PCI IRQ Routing information. This was observed on a netbook,
>> whose SATA controller mode was set to Compatibility mode.
>> The driver would then register itself to IRQ#16, but the device
>> was in fact issuing interrupts to IRQ#20.
>> No side-effects were found during testing, everything is
>> working as it did before.
>>
>> See thread:
>> http://marc.info/?t=137862230200001&r=1&w=2
>> http://www.spinics.net/lists/linux-ide/msg46173.html
>>
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>> Reviewed-by: Robert Hancock <hancockrwd@gmail.com>
> 
> That should be in linux-pm/linux-next already, isn't it there?

Hm, I didn't receive any reply back on the other mail, so I thought it got
lost somewhere. I see now that it has been applied, thanks and sorry for
the inconvenience.

-- 
Regards,
Levente Kurusa
