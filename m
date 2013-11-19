Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3KSK0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:26:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSK0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:26:36 -0500
Date: Tue, 19 Nov 2013 02:26:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Lubomir Rintel <lkundrak@v3.sk>, Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Message-ID: <20131119102630.GB5107@infradead.org>
References: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
 <20131118164533.GF3921@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118164533.GF3921@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:45:33PM +0100, Jan Kara wrote:
> dead. If it was an important filesystem in your system, the whole system is
> unusable. In kernel, we don't know whether the filesystem was important or
> not. So KERN_EMERG isn't adequate in all the cases but KERN_CRIT is
> neither. What if we made that message print also device name (it would be
> more useful anyway in that case) and you could then filter out messages for
> unimportant devices in syslogd?

What is important or unimportant?  In todays world I don't think a fs
dying is nessecarily criticial.  A root filesystem might be, but so
might be any devices that is a single point of failure required for
operation.

