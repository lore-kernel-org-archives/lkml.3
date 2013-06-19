Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016Ab3FSSCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:02:39 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:34729 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab3FSSCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:02:37 -0400
X-ASG-Debug-ID: 1371664955-0421b5021f44e00001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130617185810.GA13370@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130617134955.GB15861@redhat.com>
 <20130617173942.15057.63201@localhost.localdomain>
 <20130617182005.GA9839@redhat.com>
 <20130617184227.15057.75499@localhost.localdomain>
 <20130617185810.GA13370@redhat.com>
Message-ID: <20130619180233.5430.5764@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Date: Wed, 19 Jun 2013 14:02:33 -0400
X-ASG-Orig-Subj: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1371664955
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.134380
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Jones (2013-06-17 14:58:10)
> On Mon, Jun 17, 2013 at 02:42:27PM -0400, Chris Mason wrote:
>  > Quoting Dave Jones (2013-06-17 14:20:06)
>  > > On Mon, Jun 17, 2013 at 01:39:42PM -0400, Chris Mason wrote:
>  > >  > Quoting Dave Jones (2013-06-17 09:49:55)
>  > >  > > Hit this while running this script in a loop..
>  > >  > > https://github.com/kernelslacker/io-tests/blob/master/setup.sh
>  > >  > > [34385.251507] ------------[ cut here ]------------
>  > >  > > [34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
>  > >  > 
>  > >  > Thanks Dave, how long did you have to run the script to trigger it?
>  > >  > 
>  > >  > -chris
>  > > 
>  > > Judging by the timestamp, about 9 hours.  This is on a 3 disk (sata)
>  > > (oldish) quad opteron. Might repro faster on a more modern machine.
>  > 
>  > Exactly how did you run it?  I want to make sure I'm matching your
>  > config.
> 
> while [ 1 ];
> do
>   setup.sh
> done
> 
> You'll need to set DISK1 etc variables at the top of the script to point to
> at least 3 disks for it to scribble over.
> 
> you'll also need fsx and fsstress in /usr/local/bin.

I've tried with and without memory pressure, and let it run for about 30
hours.  So far, nothing here.  Have you seen this again?

-chris

