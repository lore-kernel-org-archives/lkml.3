Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbbAXBsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:48:17 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60251 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAXBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:48:14 -0500
Message-ID: <54C2F9C9.2000404@roeck-us.net>
Date: Fri, 23 Jan 2015 17:47:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa/mv88e6352: make mv88e6352_wait generic
References: <1422056081-30088-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1422056081-30088-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C2F9DD.00FA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 01/23/2015 03:34 PM, Vivien Didelot wrote:
> Some busy bits are available in the global register 1, such as the ATU
> Busy bit. We may want to use this function to wait for them to change,
> so add a new parameter to mv88e6352_wait() instead of hard-coding
> REG_GLOBAL2.
>
> In the meantime, since the REG_READ() macro already checks for error,
> remove the redundant check for ret < 0.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

Guenter


