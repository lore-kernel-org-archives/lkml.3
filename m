Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaJWFWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:22:48 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58014 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaJWFWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:22:47 -0400
Message-ID: <544890A5.5090807@roeck-us.net>
Date: Wed, 22 Oct 2014 22:22:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] net: dsa: Fixes and enhancements
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <CAGVrzcbohXf09pvrzayZEfcpjr8U-h-hyuYMnU0yTBJny0U27A@mail.gmail.com>
In-Reply-To: <CAGVrzcbohXf09pvrzayZEfcpjr8U-h-hyuYMnU0yTBJny0U27A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544890A6.0129,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
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

On 10/22/2014 09:45 PM, Florian Fainelli wrote:
> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>> Patch 01/14 addresses an annoying and unhelpful log message.
>>
>> Patches 02/14 and 03/14 are minor enhancements, adding support for
>> known switch revisions.
>>
>> Patches 04/14 and 05/14 add support for MV88E6352 and MV88E6176.
>>
>> Patch 06/14 adds support for hardware monitoring, specifically for
>> reporting the chip temperature, to the dsa subsystem.
>>
>> Patches 07/14 and 08/14 implement hardware monitoring for MV88E6352,
>> MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
>>
>> Patch 09/14 adds support for EEPROM access to the DSA subsystem.
>>
>> Patch 10/14 implements EEPROM access for MV88E6352 and MV88E6176.
>>
>> Patch 11/14 adds support for reading switch registers to the DSA
>> subsystem.
>>
>> Patches 12/14 amd 13/14 implement support for reading switch registers
>> to the drivers for MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
>>
>> Patch 14/14 adds support for reading additional RMON registers to the drivers
>> for  MV88E6352, MV88E6176, MV88E6123, MV88E6161, and MV88E6165.
>>
>> The series resides and was tested on top of v3.18-rc1 in a system
>> with MV88E6352. Testing in systems with 88E6131, 88E6060 and MV88E6165
>> was done earlier (I don't have access to those systems right now).
>> The series applies cleanly to net-next as of today (10/22).
>
> Besides the two nitpicking comments, this looks really good to me, thanks!
>
Thanks a lot for the quick review!

I'll wait a couple of days for additional feedback before I resubmit.

Guenter

