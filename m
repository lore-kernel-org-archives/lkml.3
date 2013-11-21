Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3KURfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:35:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3KURft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:35:49 -0500
Date: Thu, 21 Nov 2013 09:35:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH v2 2/5] locks: rename locks_remove_flock to
 locks_remove_filp
Message-ID: <20131121173549.GB12032@infradead.org>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
 <1384965906-27327-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384965906-27327-3-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:45:03AM -0500, Jeff Layton wrote:
> This function currently removes leases in addition to flock locks, so
> the name is misleading. Rename it to locks_remove_filp to indicate that
> it removes locks that are associated with a particular filp.

s/filp/file/ please.

