Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbbAYVfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:35:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53640 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbAYVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:35:41 -0500
Message-ID: <54C561A1.9040406@roeck-us.net>
Date: Sun, 25 Jan 2015 13:35:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/50] 3.10.66-stable review
References: <20150125180702.521559311@linuxfoundation.org>
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020206.54C561AD.002A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 12
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 6
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

On 01/25/2015 10:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.66 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Jan 27 18:06:25 UTC 2015.
> Anything received after that time might be too late.
>

Build results:
	total: 137 pass: 116 fail: 21
Failed builds (powerpc builds fail twice, with binutils 2.23 and 2.24):
	arm:davinci_all_defconfig
	arm:vexpress_defconfig
	arm:imx_v4_v5_defconfig
	arm:lpc32xx_defconfig
	arm:orion5x_defconfig
	arm:msm_defconfig
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	powerpc:allmodconfig
	powerpc:ppc64e_defconfig
	powerpc:ppc6xx_defconfig
	powerpc:mpc83xx_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	xtensa:allmodconfig

Qemu tests:
	total: 27 pass: 26 fail: 1
Failed tests:
	arm:arm_vexpress_defconfig

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

