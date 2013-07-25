Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3GYPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:39:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60451 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755941Ab3GYPjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:39:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+LkYwHl8STivK/PK0Nsnexyj4NgOyqgkY=
Date: Thu, 25 Jul 2013 11:38:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: orion5x: add missing mbus include
Message-ID: <20130725153856.GI23879@titan.lakedaemon.net>
References: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372762453-12018-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372762453-12018-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 12:54:13PM +0200, Sebastian Hesselbarth wrote:
> edmini_v2-setup is missing an include of linux/mbus.h which causes
> compiler error because of missing reference to mvebu_mbus_add_window.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com> 
> Cc: devicetree-discuss@lists.ozlabs.org 
> Cc: linux-kernel@vger.kernel.org 
> Cc: linux-arm-kernel@lists.infradead.org 
> ---
>  arch/arm/mach-orion5x/edmini_v2-setup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied to mvebu/stable-3.10

thx,

Jason.
