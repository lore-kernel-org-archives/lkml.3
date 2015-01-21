Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbbAUOIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:08:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44156 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbAUOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:08:32 -0500
Message-ID: <54BFB2D8.6080700@roeck-us.net>
Date: Wed, 21 Jan 2015 06:08:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Asaf Vertz <asaf.vertz@tandemg.com>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: abx500: fix format string warnings
References: <20150121080322.GA26811@ubuntu>
In-Reply-To: <20150121080322.GA26811@ubuntu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54BFB2DE.01E2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 01/21/2015 12:03 AM, Asaf Vertz wrote:
> Fixed the following warnings (reported by cppcheck):
> [drivers/hwmon/abx500.c:224]: (warning) %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> [drivers/hwmon/abx500.c:233]: (warning) %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> [drivers/hwmon/abx500.c:242]: (warning) %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
>
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
> ---

Applied.

Thanks,
Guenter


