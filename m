Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaLDNKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:10:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaLDNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:10:03 -0500
Date: Thu, 4 Dec 2014 05:09:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Dong Aisheng <dongas86@gmail.com>, tj@kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.or>,
        Dong Aisheng-B29396 <b29396@freescale.com>, r64343@freescale.com
Subject: Re: WARNING: at fs/fs-writeback.c when plug out SD card after system
 suspend/resume
Message-ID: <20141204130957.GA3957@infradead.org>
References: <CAA+hA=R2x5dUkZAh9=nHLsmaqA5YiAjEya-vQnjLx6i7fruV1w@mail.gmail.com>
 <20141204124139.GC8569@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204124139.GC8569@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 01:41:39PM +0100, Jan Kara wrote:
> We should fix bdi lifetime issues by making bdi live as long as the
> filesystem on top of it but someone has to find time to do that...

I've started that project a couple of times, but never managed to finish
it.  Let me try to resurrect it..
