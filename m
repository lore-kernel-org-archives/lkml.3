Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaJHPt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:49:57 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:41497 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaJHPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:49:56 -0400
Date: Wed, 8 Oct 2014 08:49:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/26] 3.16.5-stable review
Message-ID: <20141008154929.GA12647@roeck-us.net>
References: <20141007231848.487609292@linuxfoundation.org>
 <5434A5B1.9010408@roeck-us.net>
 <20141008044803.GC26820@kroah.com>
 <87r3yihh0p.wl%satoru.takeuchi@gmail.com>
 <20141008133252.GD5119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008133252.GD5119@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54355D21.01A1,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On Wed, Oct 08, 2014 at 06:32:52AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 08, 2014 at 09:39:50PM +0900, Satoru Takeuchi wrote:
> > At Tue, 7 Oct 2014 21:48:04 -0700,
> > Greg Kroah-Hartman wrote:
> > > 
> > > On Tue, Oct 07, 2014 at 07:47:13PM -0700, Guenter Roeck wrote:
> > > > On 10/07/2014 04:19 PM, Greg Kroah-Hartman wrote:
> > > > >This is the start of the stable review cycle for the 3.16.5 release.
> > > > >There are 26 patches in this series, all will be posted as a response
> > > > >to this one.  If anyone has any issues with these being applied, please
> > > > >let me know.
> > > > >
> > > > >Responses should be made by Thu Oct  9 23:18:40 UTC 2014.
> > > > >Anything received after that time might be too late.
> > > > >
> > > > 
> > > > Build results:
> > > > 	total: 136 pass: 136 fail: 0
> > > > Qemu tests:
> > > > 	total: 30 pass: 30 fail: 0
> > > > 
> > > > Details are available at http://server.roeck-us.net:8010/builders.
> > > 
> > > Wonderful, thanks for testing all 3 of these and letting me know.
> > 
> > Plus, all these kernels passed my test.
> > 
> >  - Test Cases:
> >    - Build this kernel.
> >    - Boot this kernel.
> >    - Build the latest mainline kernel with this kernel.
> > 
> >  - Test Tool:
> >    https://github.com/satoru-takeuchi/test-linux-stable
> > 
> >  - Test Result (kernel .config, ktest config and test log):
> >    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> > 
> >  - Build Environment:
> >    - OS: Debian Jessy x86_64
> >    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
> >    - memory: 8GB
> > 
> >  - Test Target Environment:
> >    - Debian Jessy x86_64 (KVM guest on the Build Environment)
> >    - # of vCPU: 2
> >    - memory: 2GB
> 
> Glad to hear it, I was worried about 3.14, thanks for testing and
> verifying I didn't mess anything up.
> 
Anything special to be worried about for 3.14.20 that might warrant
further / special testing ?

FWIW, I merged 3.14.19 into our target kernel. It does pass smoketest ;-).

Guenter
