Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaJWN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:28:00 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35050 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaJWN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:27:58 -0400
Message-ID: <5449025B.4080600@roeck-us.net>
Date: Thu, 23 Oct 2014 06:27:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-7-git-send-email-linux@roeck-us.net> <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com> <54488CE1.2000106@roeck-us.net> <20141023082444.GA4122@localhost.localdomain>
In-Reply-To: <20141023082444.GA4122@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5449025E.021E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 10/23/2014 01:24 AM, Richard Cochran wrote:
> On Wed, Oct 22, 2014 at 10:06:41PM -0700, Guenter Roeck wrote:
>> On 10/22/2014 09:37 PM, Florian Fainelli wrote:
>>> You probably want the number of temperature sensors to come from the
>>> switch driver, and support arbitrary number of temperature sensors?
>>
>> In that case we would need the number of sensors, pass a sensor index,
>> and create a dynamic number of attributes. The code would get much more
>> complex without real benefit unless there is such a chip - and if there is,
>> we can still change the code at that time. I would prefer to keep it simple
>> for now.
>
> Better to do it correctly, right from the start. There *will* be such
> a chip one day, and the person wanting to add it will appreciate the
> solid foundation (even if that person ends up being you ;).
>

That is really a matter of opinion; others say one should only introduce
complex infrastructure into the kernel if and when needed. I don't mind
changing the code to anticipate multiple sensors, but as I said it would
be more complex, obviously I would only have limited means to test it,
and, yes, by nature I tend to be one of the people who prefer to keep
things simple. Before I jump into doing this, I would prefer to get
guidance from the maintainer. David ?

Thanks,
Guenter

