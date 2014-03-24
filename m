Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaCXTMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:12:13 -0400
Received: from imap.thunk.org ([74.207.234.97]:45401 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbaCXTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:12:11 -0400
Date: Mon, 24 Mar 2014 15:11:59 -0400
From: tytso@mit.edu
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 19/22] ext4: Make ext4_block_zero_page_range static
Message-ID: <20140324191158.GC6896@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, willy@linux.intel.com,
	linux-ext4@vger.kernel.org
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <6ae0bcd05c2e114d3c4a7803415b6c2c8a8dadd7.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae0bcd05c2e114d3c4a7803415b6c2c8a8dadd7.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:08:45PM -0400, Matthew Wilcox wrote:
> It's only called within inode.c, so make it static, remove its prototype
> from ext4.h and move it above all of its callers so it doesn't need a
> prototype within inode.c.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Thanks, applied to the ext4 tree.

					- Ted
