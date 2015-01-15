Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbbAOA5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:57:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:38232 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbAOA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:57:38 -0500
Date: Wed, 14 Jan 2015 16:56:42 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Kevin Hilman <khilman@kernel.org>
Cc: lm-sensors@lm-sensors.org, linux-samsung-soc@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (ina2xx) Add ina231 compatible string
Message-ID: <20150115005642.GA31033@roeck-us.net>
References: <1421279852-27965-1-git-send-email-khilman@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421279852-27965-1-git-send-email-khilman@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54B71082.009E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Wed, Jan 14, 2015 at 03:57:32PM -0800, Kevin Hilman wrote:
> From: Kevin Hilman <khilman@linaro.org>
> 
> Add support for "ina231" as compatible string.
> 
> Tested with the Exynos5422-based odroid-xu3 board which has on-board
> INA231 sensors.
> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

Hi Kevin,

can you also update Documentation/hwmon/ina2xx and Documentation/hwmon/Kconfig ?

Thanks,
Guenter
