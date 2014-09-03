Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaICVqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:46:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29166 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaICVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:46:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NHO1NhuKxf1RWbkEdzZXg
Date: Wed, 3 Sep 2014 14:45:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Tom Rini <trini@ti.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: am335x-bone*: Fix model name and update
 compatibility information
Message-ID: <20140903214558.GN11766@atomide.com>
References: <1409760190-17275-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409760190-17275-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140903 09:03]:
> Beaglebone white and beaglebone black differ in tiny little aspects.
> This is the reason why we maintain seperate dts for these platforms.
> However, there is no real way to decode from dtb which platform it is
> since compatible and model name are the same for both platforms.
> 
> Fix this so that beaglebone black and beaglebone are identifiable,
> while maintaining compatibility for older zImages which might use old
> beaglebone compatible flag for black as well.
> 
> Reported-by: Tom Rini <trini@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Thanks applying into omap-for-v3.18/fixes-not-urgent.

Regards,

Tony
