Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3HGPdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:33:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab3HGPdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:33:36 -0400
Date: Wed, 7 Aug 2013 17:33:34 +0200
From: Jan Kara <jack@suse.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jan Kara <jack@suse.cz>, Davidlohr Bueso <davidlohr@hp.com>,
        "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230
 ext4_evict_inode+0x4c9/0x500 [ext4]() still in 3.11-rc3
Message-ID: <20130807153334.GC26516@quack.suse.cz>
References: <1375388059.2097.10.camel@buesod1.americas.hpqcorp.net>
 <20130801203320.GB31857@quack.suse.cz>
 <1375415926.2269.1.camel@buesod1.americas.hpqcorp.net>
 <20130807152050.GA26516@quack.suse.cz>
 <52026764.3090305@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52026764.3090305@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-08-13 08:27:32, Guenter Roeck wrote:
> On 08/07/2013 08:20 AM, Jan Kara wrote:
> >On Thu 01-08-13 20:58:46, Davidlohr Bueso wrote:
> >>On Thu, 2013-08-01 at 22:33 +0200, Jan Kara wrote:
> >>>   Hi,
> >>>
> >>>On Thu 01-08-13 13:14:19, Davidlohr Bueso wrote:
> >>>>FYI I'm seeing loads of the following messages with Linus' latest
> >>>>3.11-rc3 (which includes 822dbba33458cd6ad)
> >>>   Thanks for notice. I see you are running reaim to trigger this. What
> >>>workload?
> >>
> >>After re-running the workloads one by one, I finally hit the issue again
> >>with 'dbase'. FWIW I'm using ramdisks + ext4.
> >   Hum, I'm not able to reproduce this with current Linus' kernel - commit
> >e4ef108fcde0b97ed38923ba1ea06c7a152bab9e - I've tried with ramdisk but no
> >luck. Are you using some special mount options?
> >
> I don't see this commit in the upstream kernel ?
  It is Linus's merge of Tejun's libata fix from Tuesday...

> I tried reproducing the problem on the same system I had seen 822dbba33458cd6ad on,
> with the same workload. It has now been running since last Friday, but I have
> not seen any problems.
  Ah, OK, so it may be fixed after all. If you happen to see it again,
please let me know. Thanks!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
