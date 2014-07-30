Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaG3UQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:16:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaG3UQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:16:56 -0400
Date: Wed, 30 Jul 2014 13:16:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140730201652.GA23156@infradead.org>
References: <20140730160833.5eac00ec@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730160833.5eac00ec@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks good enough that I'll apply it to the interim vfs queue.

