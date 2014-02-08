Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaBHQky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:40:54 -0500
Received: from verein.lst.de ([213.95.11.211]:46115 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaBHQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:40:51 -0500
Date: Sat, 8 Feb 2014 17:40:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "Michael L. Semon" <mlsemon35@gmail.com>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] jfs: fix generic posix ACL regression
Message-ID: <20140208164047.GA15522@lst.de>
References: <52F54928.9050601@oracle.com> <20140208070818.GA8758@lst.de> <52F65D45.5070206@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F65D45.5070206@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 10:37:25AM -0600, Dave Kleikamp wrote:
> Your patchset removed the XATTR_SYSTEM_PREFIX bits from can_set_xattr,
> so it will not recognize the ACL as valid and return -EOPNOTSUPP.

Ah, thanks.

Consider the patch reviewed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
