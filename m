Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3KEQgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:36:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3KEQgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:36:10 -0500
Date: Tue, 5 Nov 2013 08:36:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20131105163604.GA28013@infradead.org>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
 <20120613013549.GO22848@dastard>
 <20120613033052.GT22848@dastard>
 <4FD82F89.80106@redhat.com>
 <20131105103435.GA24387@infradead.org>
 <5278CA40.8080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278CA40.8080609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:36:48AM +0100, Paolo Bonzini wrote:
> Il 05/11/2013 11:34, Christoph Hellwig ha scritto:
> > On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
> >> Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
> >> leave for holiday soon).
> > 
> > Did you ever get back to this?
> 
> I have some patches for both kernel and xfstests, but I never got round
> to testing them properly.  I don't think I'll have time soon to finish
> that, but I might coerce someone into doing it.

Feel free to send the current state my way and I'll handle it.

