Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaATRup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:50:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaATRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:50:42 -0500
Date: Mon, 20 Jan 2014 09:50:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/8] Update kernel uabi header files for x32
Message-ID: <20140120175033.GA11534@infradead.org>
References: <1388182464-28428-1-git-send-email-hjl.tools@gmail.com>
 <20131228163308.GA1638@infradead.org>
 <52DD6101.4010708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD6101.4010708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:46:41AM -0800, H. Peter Anvin wrote:
> This comment by Christoph was literally the only feedback on this
> patchset.  The definition of __kernel_[u]long_t is "the size of 'long'
> for the native kernel for the ABI".  H.J.'s patchset only affects x86
> (specifically x86-64) since on all other platforms __kernel_[u]long_t is
> simply defined as long/unsigned long.

Btw, sorry for the delay in getting back yo your question.  How about
__abi_long_t or __kabi_long_t instead?

