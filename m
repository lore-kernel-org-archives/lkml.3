Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaHXPfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:35:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHXPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:35:17 -0400
Date: Sun, 24 Aug 2014 08:35:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: scsi: #define missing include guards
Message-ID: <20140824153515.GB16490@infradead.org>
References: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:37:33PM +0200, Rasmus Villemoes wrote:
> The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
> drivers/scsi/ contain two-thirds of an include guard, but do not
> elsewhere.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Looks reasonable to me, can I get a quick review for it?

