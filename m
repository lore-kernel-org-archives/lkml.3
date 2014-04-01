Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaDANDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:03:44 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42666 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDANDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1404010108270.27402@eddie.linux-mips.org>
References: <52863D5E.7080606@linux.com>
	<alpine.LFD.2.11.1404010108270.27402@eddie.linux-mips.org>
Date: Tue, 1 Apr 2014 15:03:42 +0200
X-Google-Sender-Auth: 3aSvAo7JLW5mnkCxFkQKMDTksU0
Message-ID: <CAAsK9AH51aXUjfTUYMFbssRwZk6_J8BPktgJn9ZKZtX_r3FufQ@mail.gmail.com>
Subject: Re: [PATCH] tc: account for device_register() failure
From: Levente Kurusa <levex@linux.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-01 2:30 GMT+02:00 Maciej W. Rozycki <macro@linux-mips.org>:
> On Fri, 15 Nov 2013, Levente Kurusa wrote:
>
>> This patch makes the TURBOchannel driver bail out if the call
>> to device_register() failed.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
>
> This fixes some build warnings:
>
> drivers/tc/tc.c: In function 'tc_bus_add_devices':
> drivers/tc/tc.c:132: warning: ignoring return value of 'device_register',
> declared with attribute warn_unused_result
> drivers/tc/tc.c: In function 'tc_init':
> drivers/tc/tc.c:151: warning: ignoring return value of 'device_register',
> declared with attribute warn_unused_result
>
> Levente, thanks for your fix and apologies for the long RTT -- can you
> please resend your patch to <linux-mips@linux-mips.org> and Ralf so that
> it'll be pulled via the MIPS tree?  I'll post a follow-up update to fix
> some issues with `tc_init' that I noticed thanks to your change.

Sure, I will repost in a few hours, I just need to get home.
Thanks for the Ack!

> [...]

--
Regards,
Levente Kurusa
