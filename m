Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934860Ab3BTTgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:36:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15891 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933548Ab3BTTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:36:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,703,1355126400"; 
   d="scan'208";a="25969745"
Date: Wed, 20 Feb 2013 13:36:27 -0600
From: rkuo <rkuo@codeaurora.org>
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
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC][CFT] what's in signal.git queue
Message-ID: <20130220193627.GA15171@codeaurora.org>
References: <20130214012539.GQ4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214012539.GQ4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 01:25:39AM +0000, Al Viro wrote:
> At that point the common stem ends; as far as I'm concerned, this part is
> in never-rebase mode by now.  Then comes a bunch of per-architecture branches;
> all subject to ACK by maintainers (ones who are not MIA, that is ;-/).  Once
> maintainer(s) are OK with a branch, it's in no-rebase mode as well.  Branch
> names are of form arch-<arch name>, same as the last time around.

Tested the Hexagon patches; looks fine.

Thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
