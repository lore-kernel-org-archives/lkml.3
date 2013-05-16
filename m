Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3EPSTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:19:06 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39625 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3EPSTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:19:03 -0400
Date: Thu, 16 May 2013 11:18:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Chew Chiau Ee <chiauee85@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>
Subject: Re: [PATCH] ata_piix: add PCI IDs for Intel BayTail
Message-ID: <20130516181857.GD7171@mtj.dyndns.org>
References: <1368689609-26864-1-git-send-email-chiauee85@gmail.com>
 <20130516180728.GC7171@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516180728.GC7171@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:07:28AM -0700, Tejun Heo wrote:
> On Thu, May 16, 2013 at 03:33:29PM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > 
> > Adds IDE-mode SATA Device IDs for the Intel BayTrail platform.
> > 
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Applied to libata/for-3.10-fixes w/ stable cc added.

BTW, why is it creating a new entry?  Is there any difference with
snb?

Thanks.

-- 
tejun
