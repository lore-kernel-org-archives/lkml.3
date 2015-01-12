Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbbALOTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:19:38 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52608 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbbALOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:19:35 -0500
Message-ID: <54B3D7F3.9020504@roeck-us.net>
Date: Mon, 12 Jan 2015 06:19:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] i8k: Autodetect fan RPM multiplier
References: <1421069525-12875-1-git-send-email-pali.rohar@gmail.com> <1421069525-12875-8-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1421069525-12875-8-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54B3D7F6.00F8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/12/2015 05:32 AM, Pali Rohár wrote:
> This patch adds new function i8k_get_fan_nominal_speed() for doing SMM call
> which will return nominal fan RPM for specified fan speed. It returns nominal
> RPM value at which fan operate when speed (0, 1, 2, 3) is set. It looks like
> RPM value is not accurate, but still provides very useful information.
>
> New function i8k_get_fan_nominal_speed() is used for determinate if fan
> multiplier is 1 or 30. If function for maximal fan value success and returned
> RPM value too high (above 30000) then fan multiplier is set to 1. Otherwise
> multiplier is not changed and default value 30 is used.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Greg,

with this the entire series is ready to go.

Thanks, and sorry for the long delay on my side.

Guenter

