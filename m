Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbbAVXQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:16:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41583 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbAVXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:16:35 -0500
Message-ID: <54C184D0.6080509@roeck-us.net>
Date: Thu, 22 Jan 2015 15:16:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jean Delvare <jdelvare@suse.de>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/hwmon/adc128d818.c: Do proper sign extension
References: <1421966655-16188-1-git-send-email-linux@rasmusvillemoes.dk> <1421966655-16188-2-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421966655-16188-2-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C184D3.005A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 02:44 PM, Rasmus Villemoes wrote:
> data->temp[index] has type s16. Because of C's promotion rules,
> (data->temp[index] << 7) >> 7 is exactly the same as
> data->temp[index]. The intention was to use bit 8 as a sign bit, so do
> that using the existing API.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---

Applied.

Thanks,
Guenter

