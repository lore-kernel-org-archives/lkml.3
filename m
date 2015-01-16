Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbAPSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:31:18 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45202 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbbAPSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:31:17 -0500
Date: Fri, 16 Jan 2015 10:30:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Robert Rosengren <robert.rosengren@axis.com>,
        Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org
Cc: Johan Adolfsson <johana@axis.com>, Robert Rosengren <robertr@axis.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval
 configurable
Message-ID: <20150116183020.GA6262@roeck-us.net>
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
 <54B92596.2040206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B92596.2040206@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54B958F4.01A8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Fri, Jan 16, 2015 at 06:52:06AM -0800, Guenter Roeck wrote:
> On 01/16/2015 04:05 AM, Robert Rosengren wrote:
> >The default sample interval may be too slow for certain clients. This
> >patch makes it configurable via the platform_data.
> >
> >Signed-off-by: Robert Rosengren <robert.rosengren@axis.com>
> >Signed-off-by: Johan Adolfsson <johan.adolfsson@axis.com>
> 
> I am basically fine with the patch, though I would prefer replacing
> the entire update handling and chip access with regmap. Would you be
> interested in doing that ?
> 
I sent a couple of patches a minute ago which should take care of the issue.
Would be great if you can test it.

Thanks,
Guenter
