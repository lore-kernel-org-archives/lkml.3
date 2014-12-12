Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968181AbaLLQ0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:26:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35513 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaLLQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:26:38 -0500
Date: Fri, 12 Dec 2014 08:26:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Phil Jensen <pjensen@evernote.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/164] 3.2.65-rc1 review
Message-ID: <20141212162623.GC28564@roeck-us.net>
References: <lsq.1418364865.554543691@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.548B173D.0169,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Fri, Dec 12, 2014 at 06:14:25AM +0000, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.65 release.
> There are 164 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Dec 14 06:14:25 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 111 pass: 107 fail: 4
Failed builds:
	arm:mxs_defconfig
	mips:allmodconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu tests:
	total: 20 pass: 20 fail: 0

The arm build failure looks like it is new, but it is due to 'Inconsistent
kallsyms data' which I see randomly with arm builds, so it is not a real
concern. It may show up now because I switched from the Yocto 1.4.2 toolchain
to Yocto 1.7; as result some previously failing arm builds now pass while
others now fail.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
