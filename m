Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbaDJOYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:24:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:47568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688AbaDJOYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:24:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="518525868"
Date: Thu, 10 Apr 2014 10:23:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 15/22] Remove CONFIG_EXT2_FS_XIP and rename
 CONFIG_FS_XIP to CONFIG_FS_DAX
Message-ID: <20140410142354.GJ5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <ff35fb6b662af013eddeb295a01258b42ccaa5ae.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409095918.GG32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409095918.GG32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:59:18AM +0200, Jan Kara wrote:
> On Sun 23-03-14 15:08:41, Matthew Wilcox wrote:
> > The fewer Kconfig options we have the better.  Use the generic
> > CONFIG_FS_DAX to enable XIP support in ext2 as well as in the core.
> > 
> > Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW: Its really only 2KB of code?

I changed it in a later patch ... it's about 5kB of code.
