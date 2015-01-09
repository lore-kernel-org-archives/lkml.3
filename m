Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbbAIR7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:59:22 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44282 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbbAIR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:59:20 -0500
Date: Fri, 9 Jan 2015 09:59:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/78] 3.12.36-stable review
Message-ID: <20150109175910.GB30337@roeck-us.net>
References: <cover.1420799385.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54B0173B.0120,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
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

On Fri, Jan 09, 2015 at 11:30:32AM +0100, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.36 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Jan 13 11:29:45 CET 2015.
> Anything received after that time might be too late.
> 
Build results:
	total: 135 pass: 135 fail: 0
Qemu tests:
	total: 27 pass: 27 fail: 0

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
