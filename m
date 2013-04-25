Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3DYRew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:34:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26721 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932340Ab3DYRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:34:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/22AMsNLHNfDcofCqadeoZ5uQl9TxdXRw=
Date: Thu, 25 Apr 2013 13:34:45 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 04/21] ARM: orion5x: include linux/cpu.h
Message-ID: <20130425173445.GD32497@titan.lakedaemon.net>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910944-3033663-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:28:47PM +0200, Arnd Bergmann wrote:
> The linux/cpu.h header is no longer implictly included in this
> file, so we need to an #include statement to avoid this build
> warning:
> 
> arch/arm/mach-orion5x/common.c:339:3: error: implicit declaration of function 'cpu_idle_poll_ctrl' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
>  arch/arm/mach-orion5x/common.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Jason Cooper <jason@lakedaemon.net>

I imagine it's easiest for you to take this through a branch you already
have set up, so have it.

thx,

Jason.
