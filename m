Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaBHHIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:08:22 -0500
Received: from verein.lst.de ([213.95.11.211]:45532 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaBHHIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:08:21 -0500
Date: Sat, 8 Feb 2014 08:08:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, Christoph Hellwig <hch@lst.de>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] jfs: fix generic posix ACL regression
Message-ID: <20140208070818.GA8758@lst.de>
References: <52F54928.9050601@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F54928.9050601@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 02:59:20PM -0600, Dave Kleikamp wrote:
> -#ifdef JFS_POSIX_ACL
> +#ifdef CONFIG_JFS_POSIX_ACL

Ooops, sorry.

I don't understand the can_set_xattr move - while the check obviously
aren't needed when using the generic xattr code I don't see how they
cause harm either.

