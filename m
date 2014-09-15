Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaIOU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:28:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39140 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbaIOU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:28:31 -0400
Date: Mon, 15 Sep 2014 21:28:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/7] Prepare for adding a new readv/writev with user
 flags.
Message-ID: <20140915202828.GV7996@ZenIV.linux.org.uk>
References: <cover.1410810247.git.milosz@adfin.com>
 <e434e839351324641e10cc0a309a5c5f86e196c5.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e434e839351324641e10cc0a309a5c5f86e196c5.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:20:17PM -0400, Milosz Tanski wrote:
> Plumbing the flags argument through the vfs code so they can be passed down to
> __generic_file_(read/write)_iter function that do the acctual work.

NAK.  Put these flags into iocb, it'll be less noisy that way.
