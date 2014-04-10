Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbaDJSkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:40:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaDJSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:40:12 -0400
Date: Thu, 10 Apr 2014 20:40:10 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 17/22] Get rid of most mentions of XIP in ext2
Message-ID: <20140410184010.GC8060@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <0b13a744db9bfca33938bc1576f7eb7bfc9c41c2.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409100435.GJ32103@quack.suse.cz>
 <20140410142625.GK5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410142625.GK5727@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-04-14 10:26:25, Matthew Wilcox wrote:
> On Wed, Apr 09, 2014 at 12:04:35PM +0200, Jan Kara wrote:
> > On Sun 23-03-14 15:08:43, Matthew Wilcox wrote:
> > > The only remaining usage is userspace's 'xip' option.
> >   Looks good. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I've been thinking about this patch, and I'm not happy with it any more :-)
> 
> I want to migrate people away from using 'xip' to 'dax' without breaking
> anybody's scripts.  So I'm thinking about adding a new 'dax' option and
> having the 'xip' option print a warning and force-enable the 'dax' option.
> That way people who might have scripts to look for 'xip' in /proc/mounts
> won't break.
  Yeah, that sounds reasonable. Maybe we could even show only 'dax' in
/proc/mounts since I somewhat doubt there are any users who care. But
showing also 'xip' when used is easy enough so why not.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
