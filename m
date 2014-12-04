Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbaLDTF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:05:57 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36300 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaLDTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:05:54 -0500
Date: Thu, 4 Dec 2014 11:05:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Nishanth Menon <nm@ti.com>
Cc: Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] hwmon: (gpio-fan) Add a shutdown handler to poweroff the
 fans
Message-ID: <20141204190550.GB16925@roeck-us.net>
References: <1417712336-31070-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417712336-31070-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5480B092.023B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 12
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

On Thu, Dec 04, 2014 at 10:58:56AM -0600, Nishanth Menon wrote:
> Poweroff the fans when shutting down the system. Else,
> echo '1' > /sys/class/hwmon/hwmon0/fan1_target; poweroff leaves the
> fan running if the System power off does not drive the gpio expander
> which might control the fan power supply.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---

Applied to hwmon-next.

Thanks,
Guenter
