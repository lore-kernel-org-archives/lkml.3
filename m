Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaGMJes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:34:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaGMJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:34:41 -0400
Date: Sun, 13 Jul 2014 02:34:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] m68k updates for 3.16 (take 2)
Message-ID: <20140713093438.GA3115@infradead.org>
References: <alpine.DEB.2.02.1407131105390.7520@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407131105390.7520@ayla.of.borg>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:08:07AM +0200, Geert Uytterhoeven wrote:
>       m68k: Fix boot regression on machines with RAM at non-zero
>       m68k: Export mach_random_get_entropy to modules

What modular user of random_get_entropy is this for?  Can't find one in
the current tree, and I don't really think this is something that should
be exported either.

