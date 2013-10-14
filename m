Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3JNL03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:26:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3JNL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:26:28 -0400
Date: Mon, 14 Oct 2013 04:26:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] parisc updates for v3.12-rc5
Message-ID: <20131014112621.GA9705@infradead.org>
References: <20131013161130.GA19534@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013161130.GA19534@p100.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Geert Uytterhoeven (1):
>       parisc: Export flush_cache_page() (needed by lustre)

This one shouldn't go in - Geert sent it a bit prematurely, as Lustre
shouldn't use it just to reimplement core VM functionality (which it
shouldn't use either, but that's a separate story).

