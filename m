Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaJYDxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 23:53:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34143 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJYDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 23:53:08 -0400
Message-ID: <544A59F5.4070705@roeck-us.net>
Date: Fri, 24 Oct 2014 06:53:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-7-git-send-email-linux@roeck-us.net> <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com> <54488CE1.2000106@roeck-us.net> <20141023134706.GB25190@lunn.ch> <20141023162754.GA21343@roeck-us.net> <20141023165459.GE25190@lunn.ch> <20141023173847.GA22988@roeck-us.net> <20141023180357.GG25190@lunn.ch> <20141023184322.GA24281@roeck-us.net> <20141023195526.GH25190@lunn.ch>
In-Reply-To: <20141023195526.GH25190@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544B1EA3.0011,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 10/23/2014 12:55 PM, Andrew Lunn wrote:
[ ... ]
>
> Does hwmon offer a function to sanitise a string?
>
No, that wasn't necessary so far. The 'name' string is a constant string
provided by the driver.

> The switch index definitely should be used and i would probably
> combine that with a sanitised version of the ethernet device name and
> "dsa".
>

How is this ?

em1dsa0-isa-0000
Adapter: ISA adapter
temp1:        +38.0°C  (high = +100.0°C)

This is the sanitized network device name + 'dsa' + index.

Guenter

