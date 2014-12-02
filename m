Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaLBSeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:34:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:59658 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaLBSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:34:10 -0500
Date: Tue, 2 Dec 2014 10:32:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, arnd@arndb.de, sre@kernel.org,
        fkan@apm.com, mark.rutland@arm.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] power: reset: adjust priority of simple syscon
 reboot driver
Message-ID: <20141202183249.GA31298@roeck-us.net>
References: <1417540320-2385-1-git-send-email-stefan@agner.ch>
 <1417540320-2385-2-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417540320-2385-2-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.547E0621.0257,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Tue, Dec 02, 2014 at 06:11:58PM +0100, Stefan Agner wrote:
> Currently, all restart handler use the priority 128, including
> watchdogs. Probably most SoC have a watchdog, and some of them
> register it also as a restart handler. But if a SoC specifies
> a dedicated reboot capability using this syscon driver, this is
> usually the preferred reboot method. Hence, raise the priority
> of this driver to 192.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
