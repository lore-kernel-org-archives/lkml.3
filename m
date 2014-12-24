Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaLXJJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:09:16 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49344 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLXJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:09:13 -0500
X-IronPort-AV: E=Sophos;i="5.07,637,1413270000"; 
   d="scan'208";a="53705404"
Message-ID: <549A82B6.40105@broadcom.com>
Date: Wed, 24 Dec 2014 10:09:10 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than
 80 characters per line.
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com> <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 08:20, Kalle Valo wrote:
> Oscar Forner Martinez<oscar.forner.martinez@gmail.com>  writes:
>
>> Three lines with more than 80 characters per line have been split in several lines.
>>
>> Signed-off-by: Oscar Forner Martinez<oscar.forner.martinez@gmail.com>
>> ---
>>   drivers/bcma/driver_chipcommon.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> Just to handle the bureaucracy before v2 is submitted:
>
> To which tree should this go to? I see that earlier John has applied
> patches to drivers/bcma/, but what about now? Should I take these? John,
> any suggestions?

It is a bit of an odd ball, but there are couple of wireless driver 
relying on bcma and it is more than just a bus driver. It also does some 
steps of the device initialization (which is convenient, but not sure I 
like it). So I would hope it can stay with wireless subsystem to catch 
issue caused in that area early on.

Regards,
Arend

> Oscar, the patchwork entry for this patch looked odd. I'm guessing it
> was because your time (or timezone) is wrong:
>
> https://patchwork.kernel.org/patch/5535751/
>

