Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaLWJqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:46:21 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaLWJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:46:09 -0500
Date: Tue, 23 Dec 2014 01:46:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: livepatching tree for linux-next
Message-ID: <20141223094607.GA16445@infradead.org>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 08:52:02PM +0100, Jiri Kosina wrote:
> Hi Stephen,
> 
> a substantial amount of work has been invested into abstracing "Live 
> Patching" core functionality out of the already existing implementations, 
> so that further improvements can be built on top of it in incremental 
> steps.
> 
> The core functionality (which is self-contained) now works and has been 
> Reviewed/Acked by both interested parties (i.e. people working on kPatch 
> and kGraft) and agreed to be a common ground on which further development 
> will happen.
> 
> We plan to send a pull request for 3.20, therefore I'd like to ask you to 
> include 'for-next' branch of

This is still missing the actual patch generators, which should be
merged together with the code, otherwise we'll get a mess with forever
out of tree tools like systemtap again.
