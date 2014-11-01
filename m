Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbaKAVRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:17:05 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35872 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760216AbaKAVRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:17:01 -0400
Message-ID: <54554D85.2030308@roeck-us.net>
Date: Sat, 01 Nov 2014 14:15:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v3 30/47] x86: iris: Register with kernel power-off handler
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net> <1414425354-10359-31-git-send-email-linux@roeck-us.net> <alpine.DEB.2.11.1411012040510.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411012040510.5308@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.54554DCD.0072,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
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

On 11/01/2014 12:41 PM, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Guenter Roeck wrote:
>
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly. Register with high priority to reflect that the original code
>> overwrites existing power-off handlers.
>
> Acked-by-me for all the x86 parts of that series.
>
Thanks!

Guenter


