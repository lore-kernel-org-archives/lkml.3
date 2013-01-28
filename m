Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3A1CTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:19:36 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:28779 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740Ab3A1CTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:19:34 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xJWE2liNX4nbiAQGfScdKEsxi6RKbVnY=
Date: Sun, 27 Jan 2013 21:19:27 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: Dove: split legacy and DT setup
Message-ID: <20130128021927.GH1758@titan.lakedaemon.net>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 01:24:27AM +0100, Sebastian Hesselbarth wrote:
> In the beginning of DT for Dove it was reasonable to have it close to
> non-DT code. With improved DT support, it became more and more difficult
> to not break non-DT while changing DT code.
> 
> This patch splits up DT board setup and introduces a DOVE_LEGACY config
> to allow to remove legacy code for DT-only kernels.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-dove/Kconfig    |    5 ++
>  arch/arm/mach-dove/Makefile   |    4 +-
>  arch/arm/mach-dove/board-dt.c |  102 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-dove/common.c   |   85 ----------------------------------
>  4 files changed, 110 insertions(+), 86 deletions(-)
>  create mode 100644 arch/arm/mach-dove/board-dt.c

Applied to mvebu/boards

thx,

Jason.
