Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3L0K4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:56:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:3293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab3L0K4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:56:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,560,1384329600"; 
   d="scan'208";a="458355608"
Date: Fri, 27 Dec 2013 18:55:48 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Huajun Li <huajun.li@intel.com>
Subject: Re: [PATCH] f2fs: fix build warning for f2fs_has_inline_data()
Message-ID: <20131227105548.GA10857@hli22-desktop>
References: <1388126708-27839-1-git-send-email-haicheng.li@linux.intel.com>
 <1388136123.2101.310.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388136123.2101.310.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 06:22:03PM +0900, Jaegeuk Kim wrote:
> Hi,
> 
> Could you refer the following patch that I sent?
> 
> Re: [PATCH 5/6] f2fs: add the number of inline_data files to status info

yes, your patch should have fixed it. thanks.
