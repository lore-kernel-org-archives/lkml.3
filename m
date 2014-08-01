Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaHAWmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:42:39 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:34587 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaHAWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:42:37 -0400
Date: Sat, 2 Aug 2014 00:42:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/io.h: reorder funtions to form logical groups
Message-ID: <20140801224228.GA25980@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
 <20140719125937.GA18566@ravnborg.org>
 <20140801140956.GA1913@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801140956.GA1913@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Oh, by the way: would you prefer that I keep your patch separate or
> shall I just squash it into the one that has the major asm-generic/io.h
> cleanup?
Do whatever is the most convinient for you.
And do not bother with any attribution and such for such a simple patch.

	Sam
