Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3GXIGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:06:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36248 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3GXIGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:06:18 -0400
Date: Wed, 24 Jul 2013 17:06:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 19/22] ARM: shmobile: r8a7779: Remove '0x's from R8A7779
 DTS file
Message-ID: <20130724080616.GB10027@verge.net.au>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-19-git-send-email-lee.jones@linaro.org>
 <20130723013343.GG16481@verge.net.au>
 <20130723075232.GD26801@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723075232.GD26801@laptop>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:52:32AM +0100, Lee Jones wrote:
> On Tue, 23 Jul 2013, Simon Horman wrote:
> 
> > On Mon, Jul 22, 2013 at 11:52:38AM +0100, Lee Jones wrote:
> > > Cc: Simon Horman <horms+renesas@verge.net.au>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Acked-by: Simon Horman <horms+renesas@verge.net.au>
> > 
> > Let me know if you want me to take this through the renesas tree.
> 
> Thanks Simon. To save on conflicts, I think that's best.
> 
> I will take all orphaned patches or ones without maintainers associated
> with them through ARM SoC, but if you can take it, please do.

Understood.

I have queued this up for v3.12 in the fixes2-for-v3.12 branch
of my renesas tree on kernel.org.
