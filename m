Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaJGNmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:42:45 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58577 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:42:44 -0400
Message-ID: <5433EDCB.8060006@roeck-us.net>
Date: Tue, 07 Oct 2014 06:42:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 08/44] kernel: Move pm_power_off to common
 code
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-9-git-send-email-linux@roeck-us.net> <5433B0FE.60901@citrix.com>
In-Reply-To: <5433B0FE.60901@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5433EDD4.0029,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 10/07/2014 02:23 AM, David Vrabel wrote:
> On 07/10/14 06:28, Guenter Roeck wrote:
>> pm_power_off is defined for all architectures. Move it to common code.
>>
>> Have all architectures call do_kernel_poweroff instead of pm_power_off.
>> Some architectures point pm_power_off to machine_power_off. For those,
>> call do_kernel_poweroff from machine_power_off instead.
> [...]
>>   arch/x86/xen/enlighten.c           |  3 +--
>
> The xen bits:
>
> Acked-by: David Vrabel <david.vrabel@citrix.com>
>
> Although for a mechanical change like this I wonder if acks from all
> subsystem maintainers is really necessary.
>

Probably not, but helpful. On the other side, as others may have
noticed, sending an e-mail with that many Cc: gets it classified
as spam by many mailers. I'll have to find a way to cut that down
for the next round without offending anyone.

Guenter

