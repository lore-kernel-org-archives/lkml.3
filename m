Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LLIQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:16:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3LLIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:16:15 -0500
Date: Thu, 12 Dec 2013 00:16:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sougata Santra <sougata@tuxera.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Szabolcs Szakacsits <szaka@tuxera.com>
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
Message-ID: <20131212081613.GA6754@infradead.org>
References: <1386780980.9524.10.camel@ultrabook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386780980.9524.10.camel@ultrabook>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opendir issue is something that came up before, both in the reiser4
context and with hfsplus.  I think we'll need to put this patch in ASAP
to fix the semantic breakage caused by it, as well as other implications
of having ->lookup on a hardlinkable object.


Acked-by: Christoph Hellwig <hch@lst.de>

