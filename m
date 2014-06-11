Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFKHYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:24:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaFKHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:24:07 -0400
Date: Wed, 11 Jun 2014 00:24:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Philippe Troin <phil@fifi.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Phantom ACL-related xattrs on 3.14.4 NFS client
Message-ID: <20140611072402.GA2683@infradead.org>
References: <1402082953.28220.7.camel@ceramic.home.fifi.org>
 <CAHQdGtS2BL9u4DV=FZ0HaXO-iTNPU4hTGVR--HubNa4A_6UNog@mail.gmail.com>
 <20140607140414.GA26534@infradead.org>
 <1402195701.12743.18.camel@ceramic.home.fifi.org>
 <1402435203.24047.9.camel@ceramic.home.fifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402435203.24047.9.camel@ceramic.home.fifi.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 02:20:03PM -0700, Philippe Troin wrote:
> Trond, Christoph,
> 
> Since my last email, I've been testing 3.14.6.
> Stock 3.14.6 is still broken, and Christoph's patch does help, but does
> not entirely cure the problem.

Can you send me the output of 

getfattr -n system.posix_acl_access -e hex <file>

for the working case, and the current kernel with my previous patch?

