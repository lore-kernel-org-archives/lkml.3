Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaJKKRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:17:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaJKKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:17:30 -0400
Date: Sat, 11 Oct 2014 03:17:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Jeffery <djeffery@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
Message-ID: <20141011101728.GA16691@infradead.org>
References: <20140929142110.GA12562@fury.redhat.com>
 <20140929190509.GA2767@infradead.org>
 <5429D84B.7080902@redhat.com>
 <20140930152840.GA9666@infradead.org>
 <542ADC33.2040804@redhat.com>
 <x49fvevkfo7.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49fvevkfo7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:17:28PM -0400, Jeff Moyer wrote:
> Christoph, do you have any issues with the patch as it stands?  Whose
> tree do you think this should go through?  akpm's?

It looks good.  I think Al's tree should be fine.

