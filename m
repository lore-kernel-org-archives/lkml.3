Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaLTSIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:08:17 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54995 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLTSIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:08:16 -0500
Message-ID: <5495BAF5.9000909@roeck-us.net>
Date: Sat, 20 Dec 2014 10:07:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steven Honeyman <stevenhoneyman@gmail.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>	<201412201318.08216@pali>	<54956F4B.9070401@roeck-us.net>	<201412201354.46435@pali>	<5495AFEE.8030905@roeck-us.net> <CABz95_DzfVFbnQL_8QD=3qdswUYskGsS4k==bgMT596rKHOkuw@mail.gmail.com>
In-Reply-To: <CABz95_DzfVFbnQL_8QD=3qdswUYskGsS4k==bgMT596rKHOkuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5495BB0F.007D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On 12/20/2014 09:27 AM, Steven Honeyman wrote:
> On 20 December 2014 at 17:20, Guenter Roeck <linux@roeck-us.net> wrote:
>> I would think that it should be relatively safe
>> to assume that the first fan always exists
>
> That would be a bad idea, as this is definitely not the case:
>
> i8k-virtual-0
> Adapter: Virtual device
> fan2:        3181 RPM
> CPU:          +43.0°C
> Ambient:      +42.0°C
> SODIMM:       +36.0°C
>

Well, then he'll have to loop through fans until finding one which exists.

Guenter

