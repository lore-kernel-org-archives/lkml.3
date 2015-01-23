Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbbAWRB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:01:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40323 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbbAWRBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:01:55 -0500
Message-ID: <54C27E4D.1010108@roeck-us.net>
Date: Fri, 23 Jan 2015 09:01:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, wim@iguana.be,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Howard Chen <ibanezchen@gmail.com>, greta.zhang@mediatek.com,
        huang eddie <eddie.huang@mediatek.com>, Chen-Yu Tsai <wens@csie.org>,
        joe@perches.com
Subject: Re: [PATCH v5 0/2] ARM: mediatek: Add watchdog driver
References: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com> <CABuKBeKWU=wGuyT2u1Ndori1e8B7vAzFAmCafwLDPfAyLHkYBQ@mail.gmail.com>
In-Reply-To: <CABuKBeKWU=wGuyT2u1Ndori1e8B7vAzFAmCafwLDPfAyLHkYBQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C27E80.010D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 19
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

On 01/23/2015 06:20 AM, Matthias Brugger wrote:
> Hi all,
>
> 2015-01-13 13:28 GMT+01:00 Matthias Brugger <matthias.bgg@gmail.com>:
>> Mediatek SoCs have a watchdog driver. This patch set adds driver and DTS
>> binding. The driver also implements a restart handler to reboot the SoC.
>
> Any comments on this patch set?
>
I have it included in the set of patches that I am going to send to Wim,
hopefully this weekend.

Guenter

