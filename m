Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3CEOAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:00:32 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64524 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754580Ab3CEOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:00:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX181dGwjuDug9KO3Zvqtzn/oCCfQ7TioE+k=
Date: Tue, 5 Mar 2013 09:00:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: dove: Fix typo "COMMON_CLK_DOVE"
Message-ID: <20130305140025.GO23237@titan.lakedaemon.net>
References: <1362476098.16460.65.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362476098.16460.65.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, Mar 05, 2013 at 10:34:58AM +0100, Paul Bolle wrote:
> Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
> DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
> Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
> makes this select statement a nop. Since the Marvell Dove code includes
> <linux/clk-provider.h> we can assume that this entry needs to select
> COMMON_CLK instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  arch/arm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch, thanks for the patch.  Sebastian, could you test this and
report back?

thx,

Jason.
