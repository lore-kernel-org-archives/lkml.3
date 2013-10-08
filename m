Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3JHPxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:53:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3JHPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:53:14 -0400
Date: Tue, 8 Oct 2013 08:52:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        rkuo@codeaurora.org, tony.luck@intel.com, fenghua.yu@intel.com,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, yasutake.koichi@jp.panasonic.com,
        ralf@linux-mips.org, jonas@southpole.se, jejb@parisc-linux.org,
        deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        liqin.linux@gmail.com, lennox.wu@gmail.com, lethal@linux-sh.org,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Re: [PATCH 27/29] get_signal_to_deliver: remove regs and cookie args
Message-ID: <20131008155252.GA14080@infradead.org>
References: <1381232179-4385-1-git-send-email-richard@nod.at>
 <1381232179-4385-3-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381232179-4385-3-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:36:17PM +0200, Richard Weinberger wrote:
> Both arguments are unused, remove them.

And with the get_signal macro left as the only caller, that one should
become the implementation function.
