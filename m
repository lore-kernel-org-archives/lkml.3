Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbbAVFhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:37:08 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34044 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbAVFhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:37:04 -0500
Message-ID: <54C08C62.8010609@roeck-us.net>
Date: Wed, 21 Jan 2015 21:36:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com
CC: rgb@redhat.com, sd@queasysnail.net, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
References: <20150122045303.1347.98054.stgit@localhost>
In-Reply-To: <20150122045303.1347.98054.stgit@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C08C7F.015D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/21/2015 08:59 PM, Paul Moore wrote:
> This patchset has some important changes from the previous revision,
> namely a fix from Al Viro (included in 2/5) that resolves a boot panic
> on some systems as well as some smaller, less noteworthy fixes found
> in the linux-next announcement thread from January 20th (refcount bump
> in __audit_reusename() and a inode type in __audit_inode()).
>
> This patchset still needs some additional testing to verify that the
> audit code still functions properly (the minor fixes mentioned above)
> and there is an additional patch from Al that should be included as
> well, but I wanted to post this and push the series to the audit next
> branch quickly since a number of folks were affected by the boot panic.
>
> ---
>
> Paul Moore (5):
>        fs: rework getname_kernel to handle up to PATH_MAX sized filenames
>        fs: create proper filename objects using getname_kernel()
>        audit: enable filename recording via getname_kernel()
>        audit: fix filename matching in __audit_inode() and __audit_inode_child()
>        audit: replace getname()/putname() hacks with reference counters
>
Hi Paul,

What is the baseline for this patch set ? Obviously -next won't work,
and it does not apply to mainline either.

Thanks,
Guenter

