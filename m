Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaISKwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:52:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaISKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:52:23 -0400
Date: Fri, 19 Sep 2014 03:52:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 2/5] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140919105220.GC14281@infradead.org>
References: <cover.1410983998.git.milosz@adfin.com>
 <a5d46efa590f0d32cf209495cdb897ffadb859c5.1410983999.git.milosz@adfin.com>
 <20140918184823.GA10155@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918184823.GA10155@birch.djwong.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:48:23AM -0700, Darrick J. Wong wrote:
> A few months ago I was working on extending these interfaces (well, the
> p{read,write}* ones and AIO) to tack on an IO extension buffer at the end of
> the syscall arguments.

Honestly, that proposal is so but ugly that I treated it as an April
first joke.  I don't really think we want any of that overload mess.
