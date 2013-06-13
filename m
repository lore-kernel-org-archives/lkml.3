Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3FMCof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:44:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:3275 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3FMCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="349051350"
Date: Thu, 13 Jun 2013 10:44:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [scsi] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one()
Message-ID: <20130613024427.GA11085@localhost>
References: <20130613013032.GA7558@localhost>
 <1371090883.1978.61.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371090883.1978.61.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:34:43PM -0700, James Bottomley wrote:
> On Thu, 2013-06-13 at 09:30 +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit a256ba092ec57213f96059d41ac5473ff92f5e7c
> > Author: Nicholas Bellinger <nab@linux-iscsi.org>
> > Date:   Sat May 18 02:40:43 2013 -0700
> > 
> >     scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
> >     
> >     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> You may be evaluating a bogus branch because no such commit has darkened
> the SCSI list, so it obviously can't be on upstream track.

Yeah, sorry I should probably not CC linux-scsi.

The bug is still in a private tree:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git  scsi-mq

Thanks,
Fengguang
