Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3JROsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:48:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37579 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3JROsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:48:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NNHHUU/VRBidBUiBlh3DjDKJhzt+Yshc=
Date: Fri, 18 Oct 2013 10:47:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
Message-ID: <20131018144741.GL22434@titan.lakedaemon.net>
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
> With legacy devices converted to DT and a proper ethernet MAC
> workaround, we can now remove the clk workarounds for legacy
> devices. While at it, also cleanup the list of includes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> As a follow-up patch for latest mvebu PRs, this patch is based on
>  git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   42 ++----------------------------------
>  1 files changed, 3 insertions(+), 39 deletions(-)

Applied to mvebu/soc

thx,

Jason.
