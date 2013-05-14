Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3ENTkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3ENTkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:40:06 -0400
Date: Tue, 14 May 2013 21:41:19 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v2] AHCI: Make distinct names for ports in
 /proc/interrupts
Message-ID: <20130514194118.GA20747@dhcp-26-207.brq.redhat.com>
References: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
 <51803A7F.8080608@pobox.com>
 <20130507083836.GA18862@dhcp-26-207.brq.redhat.com>
 <20130514185642.GT6795@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514185642.GT6795@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:56:42AM -0700, Tejun Heo wrote:
> On Tue, May 07, 2013 at 10:38:37AM +0200, Alexander Gordeev wrote:
> > Currently all interrupts assigned to AHCI ports show up in
> > '/proc/interrupts' as 'ahci'. This fix adds port numbers as
> > suffixes and hence makes the descriptions distinct.
> > 
> > Reported-by: Jan Beulich <JBeulich@suse.com>
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> 
> Patch doesn't apply.  Can you please refresh it on top of the
> following git branch?

Well, this patch is on top of a previously posted another patch
"[PATCH RFC 1/1] AHCI: Optimize interrupt processing". Jeff said
he applied the latter, but I did not notice it made to his repo.

Would you consider to accept "AHCI: Optimize interrupt processing"
patch first, or still refresh this one?

>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11
> 
> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
