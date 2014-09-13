Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaIMVvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 17:51:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64518 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160AbaIMVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 17:51:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/SgA9GalgceDGdlngmP0HuUHb4xY4Nez4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5A4BF5E0CB7
Date: Sat, 13 Sep 2014 17:51:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] arm: mach-orion5x: Convert pr_warning to pr_warn
Message-ID: <20140913215123.GK30828@titan.lakedaemon.net>
References: <cover.1410632834.git.joe@perches.com>
 <b438c7c54306f095a150e50df41fbba4d515c2f8.1410632835.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b438c7c54306f095a150e50df41fbba4d515c2f8.1410632835.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

On Sat, Sep 13, 2014 at 11:31:17AM -0700, Joe Perches wrote:
> Use the more common pr_warn.
> 
> Other miscellanea:
> 
> o Realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/mach-orion5x/dns323-setup.c           | 8 ++++----
>  arch/arm/mach-orion5x/terastation_pro2-setup.c | 2 +-
>  arch/arm/mach-orion5x/ts209-setup.c            | 2 +-
>  arch/arm/mach-orion5x/ts409-setup.c            | 2 +-
>  arch/arm/mach-orion5x/ts78xx-setup.c           | 4 ++--
>  5 files changed, 9 insertions(+), 9 deletions(-)

Applied to mvebu/soc with Andrew's Ack.

thx,

Jason.
