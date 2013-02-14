Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3BNKXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:23:36 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39350 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3BNKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:23:32 -0500
Date: Thu, 14 Feb 2013 11:23:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>, Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC][CFT] what's in signal.git queue
Message-ID: <20130214112306.30ab728c@mschwide>
In-Reply-To: <20130214012539.GQ4503@ZenIV.linux.org.uk>
References: <20130214012539.GQ4503@ZenIV.linux.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13021410-3548-0000-0000-0000048C7858
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 01:25:39 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> At that point the common stem ends; as far as I'm concerned, this part is
> in never-rebase mode by now.  Then comes a bunch of per-architecture branches;
> all subject to ACK by maintainers (ones who are not MIA, that is ;-/).  Once
> maintainer(s) are OK with a branch, it's in no-rebase mode as well.  Branch
> names are of form arch-<arch name>, same as the last time around.

Just tested the signal.git master branch (didn't see any additional commit on
the arch-s390 branch). Works for me and the test suite of gdb does not come up
with any new unexpected failures. So for the s390 parts:

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

