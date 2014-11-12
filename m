Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaKLQRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:17:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51709 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:17:37 -0500
Date: Wed, 12 Nov 2014 08:17:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/203] 3.14.24-stable review
Message-ID: <20141112161731.GA25697@roeck-us.net>
References: <20141112011542.686743533@linuxfoundation.org>
 <5462FE3A.7060601@roeck-us.net>
 <20141112063600.GA7367@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112063600.GA7367@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54638821.0017,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Wed, Nov 12, 2014 at 03:36:00PM +0900, Greg Kroah-Hartman wrote:
> On Tue, Nov 11, 2014 at 10:29:14PM -0800, Guenter Roeck wrote:
> > On 11/11/2014 05:14 PM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.14.24 release.
> > >There are 203 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Fri Nov 14 01:15:14 UTC 2014.
> > >Anything received after that time might be too late.
> > >
> > 
> > Build results:
> > 	total: 137 pass: 134 fail: 3
> > Failed builds:
> > 	powerpc:allmodconfig (binutils 2.23)
> > 	powerpc:allmodconfig (binutils 2.24)
> > 	xtensa:allmodconfig
> > 
> > Qemu tests:
> > 	total: 30 pass: 30 fail: 0
> > 
> > Builds fail due to
> > 
> > drivers/of/selftest.c: In function 'of_selftest':
> > drivers/of/selftest.c:436:2: error: implicit declaration of function 'of_selftest_property_match_string' [-Werror=implicit-function-declaration]
> >   of_selftest_property_match_string();
> >   ^
> > drivers/of/selftest.c: At top level:
> > drivers/of/selftest.c:135:20: warning: 'of_selftest_property_string' defined but not used [-Wunused-function]
> >  static void __init of_selftest_property_string(void)
> >                     ^
> > 
> > as mentioned earlier.
> 
> I've now fixed this one, if you want to pull the latest stable-git tree.
> 
Confirmed.

Thanks,
Guenter
