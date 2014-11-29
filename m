Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaK2QZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:25:01 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54500 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaK2QY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:24:58 -0500
Message-ID: <5479F358.8060506@roeck-us.net>
Date: Sat, 29 Nov 2014 08:24:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411291709.35406@pali>
In-Reply-To: <201411291709.35406@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5479F359.01A7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 11/29/2014 08:09 AM, Pali Rohár wrote:
> On Saturday 29 November 2014 17:04:07 Pali Rohár wrote:
>> This patch adds labels for temperature sensors if SMM function
>> with EAX register 0x11a3 reports it. These informations was
>> taken from DOS binary NBSVC.MDM.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> ---
>>   drivers/char/i8k.c |  110
>> +++++++++++++++++++++++++++++++++++++++++----------- 1 file
>> changed, 88 insertions(+), 22 deletions(-)
>
> I tested patch on Latitude E6440 and i8k CPU & GPU temps match
> intel coretemp & amd radeion temps.
>
> But I would like if somebody with other Dell laptop can test if
> temperature labels are correct...
>

I have a couple; I'll try to give it a test this weekend.

Guenter

