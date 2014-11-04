Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaKDNi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:38:28 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47123 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKDNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:38:24 -0500
Date: Tue, 4 Nov 2014 08:38:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [AHCI] XFS (sda3): metadata I/O error: block 0x941ce20
 ("xlog_iodone") error 5 numblks 64
Message-ID: <20141104133820.GA13567@htj.dyndns.org>
References: <20141104042522.GA14917@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104042522.GA14917@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:25:22PM +0800, Fengguang Wu wrote:
> Hi Tejun,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata for-3.18-fixes
> commit 61e268068c92ed000f078dc1ab71d1228439fecd ("Revert "AHCI: Optimize single IRQ interrupt processing"")

Yeah, there's a dependent revert that I missed.  libata/for-3.18-fixes
has been rebased, so this shouldn't happen anymore.

Thanks.

-- 
tejun
