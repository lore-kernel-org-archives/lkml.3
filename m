Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3LLIS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:18:58 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3LLISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:18:55 -0500
Date: Thu, 12 Dec 2013 00:18:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Sougata Santra <sougata@tuxera.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Szabolcs Szakacsits <szaka@tuxera.com>
Subject: Re: [PATCH] hfsplus: Remove hfsplus_file_lookup
Message-ID: <20131212081845.GB6754@infradead.org>
References: <1386780980.9524.10.camel@ultrabook>
 <AE333CDA-DD74-42B8-92F4-551ACCAD8AFA@dubeyko.com>
 <20131211191153.GZ10323@ZenIV.linux.org.uk>
 <8B102D87-1A22-4ACA-9438-CA66133C2AB1@cam.ac.uk>
 <1386830101.3972.27.camel@slavad-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386830101.3972.27.camel@slavad-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:35:01AM +0400, Vyacheslav Dubeyko wrote:
> I think that I can implement support of resource forks by means of xattr
> way. Also, currently, I am implementing HFS+ compressed files support.
> So, I can clean up old-fashioned way of resource forks support in HFS+
> driver because of necessity to rework it anyway. The suggested patch
> doesn't make all necessary cleanup, from my viewpoint.
> 
> Any comments?

The patch is required band aid to fix easily user visible and
triggerable breakage.  As such it should go in ASAP and not be blocked
by additional cleanups.  That doesn't mean that I wouldn't love to see
your planned rework and additional cleanups later.

