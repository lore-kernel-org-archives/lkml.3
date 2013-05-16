Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3EPFE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:04:57 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53400 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3EPFE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:04:56 -0400
Date: Thu, 16 May 2013 14:04:53 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the renesas tree with Linus' tree
Message-ID: <20130516050450.GA13842@verge.net.au>
References: <20130516132253.8865ca7b6503bd6fe9e6b05a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516132253.8865ca7b6503bd6fe9e6b05a@canb.auug.org.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 01:22:53PM +1000, Stephen Rothwell wrote:
> Hi Simon,
> 
> Today's linux-next merge of the renesas tree got a conflict in
> arch/arm/mach-shmobile/board-lager.c between commit 65be2de17aae ("ARM:
> shmobile: use r8a7790 timer setup code on Lager") from Linus' tree and
> commit 993340a1390d ("ARM: shmobile: use r8a7790 timer setup code on
> Lager") from the renesas tree.
> 
> These are the same patch but different commits :-( and there are further
> commits touching this file in the renesas tree.  Please clean up your
> tree and remove anything that has already gone upstream as different
> patches.  I used the renesas tree version of this file.


Sorry about that. I am working on re-basing my branches on
top of v3.10-rc1 and I have confirmed that in my current local
branches the problem you describe is no longer present.
I plan to push the refreshed branches, including a new next branch
for linux-next, once a few bug-fix patches have been reviewed.

