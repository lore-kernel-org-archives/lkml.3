Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaJBSAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaJBSA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:00:29 -0400
Date: Thu, 2 Oct 2014 14:00:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: dm-raid: add RAID discard support
Message-ID: <20141002180020.GA26451@redhat.com>
References: <7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
 <20140924142157.33475baa@notabene.brown>
 <5422A4C4.4020707@redhat.com>
 <20141001125625.1e0d356a@notabene.brown>
 <20141001133237.GB16521@redhat.com>
 <20141002093403.25cc832f@notabene.brown>
 <20141002013135.GA21091@redhat.com>
 <20141002120049.58dba551@notabene.brown>
 <20141002140410.1b379f74@notabene.brown>
 <20141002135232.GA25298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002135232.GA25298@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2014 at  9:52am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> Thanks Neil, I'll get something comparable staged for dm-raid for 3.18
> (less urgency given that dm-raid doesn't yet support discards).

FYI, I've staged the following dm-raid change in linux-next for 3.18:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=bfc3f335f9886b68d281240aab751b96259d8860
