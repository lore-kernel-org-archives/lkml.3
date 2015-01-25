Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbbAYTH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:07:27 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34851 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbbAYTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:07:21 -0500
Message-ID: <54C53EE4.4070109@roeck-us.net>
Date: Sun, 25 Jan 2015 11:07:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>
CC: linux-pm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] power/reset: arm-versatile: Register with kernel
 restart handler
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net> <20150125184017.GA29704@earth.universe>
In-Reply-To: <20150125184017.GA29704@earth.universe>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C53EE7.0193,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
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

On 01/25/2015 10:40 AM, Sebastian Reichel wrote:
> Hi,
>
> On Sun, Jan 25, 2015 at 10:13:37AM -0800, Guenter Roeck wrote:
>> Register with kernel restart handler instead of setting arm_pm_restart
>> directly. Select high priority since the restart handler is instantiated
>> through devicetree, indicating that it should be used if configured.
>
> This does not apply clean for me. Please rebase on top of
>
> http://git.infradead.org/battery-2.6.git/
>

Hi Sebastian,

Sure, will do. I assume you mean battery/next-next since it applies cleanly
to battery/master.

Thanks,
Guenter

