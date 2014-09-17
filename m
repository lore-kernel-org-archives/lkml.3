Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaIQESS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:18:18 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50853 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaIQESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:18:16 -0400
Message-ID: <54190B83.1040503@roeck-us.net>
Date: Tue, 16 Sep 2014 21:18:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        herrmann.der.user@googlemail.com, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
CC: boris.ostrovsky@oracle.com
Subject: Re: [PATCH V2 2/2] hwmon, fam15h_power: Add support for two more
 processors
References: <1410897496-2600-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
In-Reply-To: <1410897496-2600-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54190B88.0043,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
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

On 09/16/2014 12:58 PM, Aravind Gopalakrishnan wrote:
> Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri) processors can
> report 'power_crit' value. So, adding their respective device ids.
>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Applied.

Thanks,
Guenter


