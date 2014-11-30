Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaK3Utm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:49:42 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57712 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3Utl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:49:41 -0500
Message-ID: <547B82E3.50701@roeck-us.net>
Date: Sun, 30 Nov 2014 12:49:39 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 2/3] i8k: Register only temperature sensors which have
 labels
References: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com> <1417379178-5236-2-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1417379178-5236-2-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.547B82E5.00E7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
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

On 11/30/2014 12:26 PM, Pali Rohár wrote:
> Detect presense of sensor by calling type function instead trying to read
> temperature value. Type function is working also for sensors which are temporary
> turned off (e.g on GPU which is turned off). Dell DOS binary NBSVC.MDM is doing
> similar checks, so we should do that too.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

