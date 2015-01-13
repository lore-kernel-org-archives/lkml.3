Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbbAMMYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:24:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46796 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbAMMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:24:09 -0500
Date: Tue, 13 Jan 2015 04:24:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Masanari Iida <standby24x7@gmail.com>
Cc: wim@iguana.be, thomas.mingarelli@hp.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: watchdog: hpwdt: Fix initialization message in hpwdt.c
Message-ID: <20150113122401.GA2133@roeck-us.net>
References: <1413977075-8938-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413977075-8938-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54B50E68.0210,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Wed, Oct 22, 2014 at 08:24:35PM +0900, Masanari Iida wrote:
> allow_kdump was enabled as default since following commit.
> 
> commit a089361cf5f1d6a5295aa5385238bd044998e1e9,
> watchdog: hpwdt: Unregister NMI events on exit.
> 
> But the initialization message was not modified.
> So it still shows
> 
>   HP Watchdog Timer Driver: NMI decoding initialized,
>   allow kernel dump: ON (default = 0/OFF)    <=
> 
> This "default = 0/OFF" message may confuse users.
> Fix it as "default = 1/ON".
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
