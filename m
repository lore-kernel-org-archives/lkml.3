Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaGQIDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:03:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaGQIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:03:07 -0400
Date: Thu, 17 Jul 2014 01:03:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v2 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140717080301.GA14263@infradead.org>
References: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:37:56PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This makes the implementation simpler by stuffing the struct on
> the driver and just letting the driver iinsert it and remove it
> onto the sb list. This avoids the kzalloc() completely.

Again, NAK.  Make btrfs report the proper anon dev_t in stat and
everything will just work.

