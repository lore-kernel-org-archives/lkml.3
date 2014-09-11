Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaIKNaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:30:17 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34629 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaIKNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:30:13 -0400
Message-ID: <5411A3DE.4050509@roeck-us.net>
Date: Thu, 11 Sep 2014 06:30:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/131] 3.2.63-rc1 review
References: <lsq.1410438733.176537304@decadent.org.uk>
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.5411A3E5.00FA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/11/2014 05:32 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.63 release.
> There are 131 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 13 12:32:13 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 111 pass: 106 fail: 5
Failed builds:
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	mips:allmodconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu test results:
	total: 18 pass: 17 fail: 1
Failed tests:
	microblaze:microblaze_defconfig

Results are as expected and an improvement over previous releases,
where sparc64:allmodconfig used to fail as well. The failing qemu
test was added to the list of tests only recently and is a known
problem.

Guenter

