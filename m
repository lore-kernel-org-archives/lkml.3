Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab3AaNnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:43:37 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61492 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3AaNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130130192018.GB20100@spo001.leaseweb.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
	<1358128918-4415-2-git-send-email-mc74hc00@gmail.com>
	<20130130192018.GB20100@spo001.leaseweb.com>
Date: Thu, 31 Jan 2013 22:43:32 +0900
Message-ID: <CAHh0gOjagPA2SJh+crZtL=eSFqQBJRkDB64_ffdKuJaCtHOwkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] sp5100_tco: Write back the original value to reserved
 bits, instead of zero
From: t t <mc74hc00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/31 Wim Van Sebroeck <wim@iguana.be>:
> Hi,
>
>> In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
>> reserved bits. The module, however, shouldn't depend on specific default
>> value, and should perform a read-merge-write operation for the reserved
>> bits.
>>
>> This patch makes the sp5100_tco module perform a read-merge-write operation
>> on all the chipset (sp5100, sb7x0, sb8x0 or later).
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
>> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
>
> Added to linux-watchdog-next.

Thanks Wim!


Kind regards,
Takahisa
