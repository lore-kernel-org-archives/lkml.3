Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbbAPUbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:31:05 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36385 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbAPUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:31:03 -0500
Date: Fri, 16 Jan 2015 12:30:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Robert Rosengren <robert.rosengren@axis.com>
Cc: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Robert Rosengren <robertr@axis.com>,
        Johan Adolfsson <johana@axis.com>
Subject: Re: [PATCH] hwmon: (ads7828) Make sample interval configurable
Message-ID: <20150116203005.GA6524@roeck-us.net>
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54B97504.024D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Fri, Jan 16, 2015 at 01:05:22PM +0100, Robert Rosengren wrote:
> The default sample interval may be too slow for certain clients. This
> patch makes it configurable via the platform_data.
> 
> Signed-off-by: Robert Rosengren <robert.rosengren@axis.com>
> Signed-off-by: Johan Adolfsson <johan.adolfsson@axis.com>

Robert,

can you send me the output of i2cdump for this chip ? I would like
to write a module test for the driver.

Thanks,
Guenter
