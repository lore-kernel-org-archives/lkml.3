Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbaJaKfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:35:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52733 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbaJaKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:35:11 -0400
Date: Fri, 31 Oct 2014 10:35:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
Message-ID: <20141031103506.GI7996@ZenIV.linux.org.uk>
References: <20140929142110.GA12562@fury.redhat.com>
 <20141031085722.GA17398@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031085722.GA17398@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 01:57:22AM -0700, Christoph Hellwig wrote:
> Could someone please pick up this regression fix?

Done.
