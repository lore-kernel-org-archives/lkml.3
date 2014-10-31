Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422912AbaJaCxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:53:21 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35638 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422693AbaJaCxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:53:20 -0400
Message-ID: <5452F99D.5080201@roeck-us.net>
Date: Thu, 30 Oct 2014 19:53:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/15] net: dsa: Add support for switch EEPROM access
References: <1414604707-22407-1-git-send-email-linux@roeck-us.net> <1414604707-22407-10-git-send-email-linux@roeck-us.net> <20141030211131.GB32139@lunn.ch> <20141030223951.GA19489@roeck-us.net> <20141031010039.GA29492@roeck-us.net> <20141031024044.GA4082@lunn.ch>
In-Reply-To: <20141031024044.GA4082@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5452F9A0.0022,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
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

On 10/30/2014 07:40 PM, Andrew Lunn wrote:
>> As suspected, ethtool will attempt to read a zero-length eeprom.
>>
>> The following patch should solve the problem. Not sure if it is worth it,
>> though, since this will change behavior for existing drivers.
>
> Yes, it changes behaviour, but it does make it more consistent.
>
> Probably it should be up to core network people to decide if this is
> the write fix or leave it as is.
>

s/write/right/.

The patch shows up in the netdev patchwork. David marked it as RFC,
so we'll see where it goes.

Thanks,
Guenter

