Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaDBTYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:24:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:44719 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbaDBTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:24:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,782,1389772800"; 
   d="scan'208";a="485977429"
Date: Wed, 2 Apr 2014 15:24:46 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/22] axonram: Fix bug in direct_access
Message-ID: <20140402192446.GC27299@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <e3ede380dd37d3cae604ee20198e568c9eb4fa00.1395591795.git.matthew.r.wilcox@intel.com>
 <20140329162216.GC1211@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329162216.GC1211@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 05:22:16PM +0100, Jan Kara wrote:
> On Sun 23-03-14 15:08:29, Matthew Wilcox wrote:
> > The 'pfn' returned by axonram was completely bogus, and has been since
> > 2008.
>   Maybe time to drop the driver instead? When noone noticed for 6 years, it
> seems pretty much dead... Or is there some possibility the driver can get
> reused for new HW?

It may be in use, just not with the -o xip option to ext2 ... I can't
find out which of the various vendors on the internet that are called
'Axon' that this device was originally supposed to support.  I suspect
it's dead, since it's DDR-2, but *shrug*, it costs little to fix it.
