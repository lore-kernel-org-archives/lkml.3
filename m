Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaIWE6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:58:45 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:46692 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIWE6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:58:43 -0400
Message-ID: <5420FDFB.8040203@roeck-us.net>
Date: Mon, 22 Sep 2014 21:58:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zefan Li <lizf@kernel.org>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, satoru.takeuchi@gmail.com,
        Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 00/45] 3.4.104-rc1 review
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020204.5420FE03.0024,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 2
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
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

On 09/22/2014 07:27 PM, Zefan Li wrote:
> From: Zefan Li <lizefan@huawei.com>
>
> This is the start of the stable review cycle for the 3.4.104 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Sep 25 02:03:31 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 116 fail: 3
Failed builds:
	score:defconfig
	sparc64:allmodconfig
	xtensa:allmodconfig

Qemu test results:
	total: 18 pass: 17 fail: 1
Failed tests:
	arm:arm_versatile_defconfig

This is an improvement over the previous release, where we had six build
failures. The failing qemu test is a recent addition which is expected
to fail for the 3.4 kernel. The failure is due to Versatile SCSI driver
and interrupt handling problems; those were fixed in later kernels but
would be difficult to back-port.

Guenter

