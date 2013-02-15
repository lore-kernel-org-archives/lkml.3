Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3BOVqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:46:40 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:48989 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670Ab3BOVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:46:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CcmIVVClzfL0nlEozMd/MjFCAmoDDMvo=
Date: Fri, 15 Feb 2013 16:46:33 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Dove: convert usb host controller to DT
Message-ID: <20130215214633.GG14746@titan.lakedaemon.net>
References: <1359388448-14370-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359388448-14370-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 04:54:08PM +0100, Sebastian Hesselbarth wrote:
> With DT support for orion-ehci also convert Dove to it and
> remove the legacy calls and clock aliases.
> 
> This patch is based on "ARM: Dove: split legacy and DT setup"
> applied to mvebu/boards recently.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove.dtsi   |   16 ++++++++++++++++
>  arch/arm/mach-dove/board-dt.c |   10 ----------
>  2 files changed, 16 insertions(+), 10 deletions(-)

Applied to mvebu/dt

thx,

Jason.
