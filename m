Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3ENS4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:56:49 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:63204 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3ENS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:56:47 -0400
X-Greylist: delayed 2470 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 14:56:47 EDT
Date: Tue, 14 May 2013 11:56:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v2] AHCI: Make distinct names for ports in
 /proc/interrupts
Message-ID: <20130514185642.GT6795@mtj.dyndns.org>
References: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
 <51803A7F.8080608@pobox.com>
 <20130507083836.GA18862@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507083836.GA18862@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 10:38:37AM +0200, Alexander Gordeev wrote:
> Currently all interrupts assigned to AHCI ports show up in
> '/proc/interrupts' as 'ahci'. This fix adds port numbers as
> suffixes and hence makes the descriptions distinct.
> 
> Reported-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Patch doesn't apply.  Can you please refresh it on top of the
following git branch?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11

Thanks.

-- 
tejun
