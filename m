Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3JJH3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:29:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:43446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab3JJH3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:29:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="408698519"
Date: Thu, 10 Oct 2013 15:29:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
 pointer dereference at 00000003
Message-ID: <20131010072944.GA26888@localhost>
References: <20131009073910.GA387@localhost>
 <20131010005900.GE2025@devil.localdomain>
 <20131010062313.GA19097@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010062313.GA19097@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 02:23:13PM +0800, Fengguang Wu wrote:
> Dave,
> 
> Here are the first oops chunks that show up in the 3.12-rc4 kernel
> with only XFS build in. Attached is the kconfig and one full dmesg.
> 
> Hope there are more clues in them. I'll further test whether the
> problems disappear if further disabling XFS..

Yeah I just confirmed that disabling XFS quiets the error messages.

Thanks,
Fengguang
