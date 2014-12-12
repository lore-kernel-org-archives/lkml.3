Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbaLLHNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:13:45 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51583 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaLLHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:13:44 -0500
Date: Fri, 12 Dec 2014 16:13:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Dave Airlie <airlied@gmail.com>
Cc: Joerg Roedel <jroedel@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>
Subject: Re: drm pull waiting on other trees
Message-ID: <20141212071340.GC3362@verge.net.au>
References: <CAPM=9tw6DmAU0rwPzTO=yPt5s6xLMTP=VuyPR7ObtkFNquf5HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tw6DmAU0rwPzTO=yPt5s6xLMTP=VuyPR7ObtkFNquf5HA@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, Dec 12, 2014 at 03:28:06PM +1000, Dave Airlie wrote:
> Hey Simon, Joerg,
> 
> I've got merges from you guys in my tree that don't seem to be in
> Linus's tree yet, I'm a bit concerned as the drm merge is a large one
> and I'd like to have it in Linus' tree ASAP.
> 
> The rockchip iommu and bunch of shmobile/rcar changes are what I
> believe is currently stopping me.

If you give me a specific tag or commit id I can investigate further but
I'm assuming it is renesas-dt-du-for-v3.19 (0ee56d403549fd97d) then it has
been accepted by the by Arnd (CCed) and I believe he or one of the other
Arm SoC maintainers (also CCed) have a plan to submit it to Linus (most
likely as part of a larger pull-request).

FWIW, I would also very much like the shmobile/rcar changes in Linus's tree :)
