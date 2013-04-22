Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3DVIv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3DVIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:51:56 -0400
Date: Mon, 22 Apr 2013 09:51:45 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 66/72] mtdchar: fix offset overflow detection
Message-ID: <20130422085145.GC3222@hercules>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
 <1366276617-3553-67-git-send-email-luis.henriques@canonical.com>
 <1366602998.3408.146.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366602998.3408.146.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 04:56:38AM +0100, Ben Hutchings wrote:
> On Thu, 2013-04-18 at 10:16 +0100, Luis Henriques wrote:
> > 3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > commit 9c603e53d380459fb62fec7cd085acb0b74ac18f upstream.
> [...]
> 
> There are further problems with mtdchar_mmap(), and David recommended to
> apply commit f5cf8f07423b 'mtd: Disable mtdchar mmap on MMU systems'
> instead.

Ok, I missed that.  I'll replace it by f5cf8f07423b.  Thanks.

Cheers,
--
Luis
