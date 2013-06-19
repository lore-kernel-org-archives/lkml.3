Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3FSSfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab3FSSfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:35:00 -0400
Date: Wed, 19 Jun 2013 14:34:50 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Message-ID: <20130619183450.GA26752@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20130617134955.GB15861@redhat.com>
 <20130617173942.15057.63201@localhost.localdomain>
 <20130617182005.GA9839@redhat.com>
 <20130617184227.15057.75499@localhost.localdomain>
 <20130617185810.GA13370@redhat.com>
 <20130619180233.5430.5764@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619180233.5430.5764@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:02:33PM -0400, Chris Mason wrote:
 > Quoting Dave Jones (2013-06-17 14:58:10)
 > > On Mon, Jun 17, 2013 at 02:42:27PM -0400, Chris Mason wrote:
 > >  > Quoting Dave Jones (2013-06-17 14:20:06)
 > >  > > On Mon, Jun 17, 2013 at 01:39:42PM -0400, Chris Mason wrote:
 > >  > >  > Quoting Dave Jones (2013-06-17 09:49:55)
 > >  > >  > > Hit this while running this script in a loop..
 > >  > >  > > https://github.com/kernelslacker/io-tests/blob/master/setup.sh
 > >  > >  > > [34385.251507] ------------[ cut here ]------------
 > >  > >  > > [34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
 > >  > >  > 
 > >  > >  > Thanks Dave, how long did you have to run the script to trigger it?
 > >  > > 
 > >  > > Judging by the timestamp, about 9 hours.  This is on a 3 disk (sata)
 > >  > > (oldish) quad opteron. Might repro faster on a more modern machine.
 > >  > 
 > >  > Exactly how did you run it?  I want to make sure I'm matching your
 > >  > config.
 > > 
 > > while [ 1 ];
 > > do
 > >   setup.sh
 > > done
 > > 
 > > You'll need to set DISK1 etc variables at the top of the script to point to
 > > at least 3 disks for it to scribble over.
 > > 
 > > you'll also need fsx and fsstress in /usr/local/bin.
 > 
 > I've tried with and without memory pressure, and let it run for about 30
 > hours.  So far, nothing here.  Have you seen this again?

yeah, one time I hit it within 30 minutes.

	Dave

