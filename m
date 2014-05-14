Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaENVpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:45:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51258 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaENVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:45:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/UhpZ6UVkMBLpjh1Xkvlmi
Date: Wed, 14 May 2014 14:45:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: AM33XX: fix ethernet and mdio default state
Message-ID: <20140514214534.GK27426@atomide.com>
References: <1399539456-555-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399539456-555-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johan Hovold <jhovold@gmail.com> [140508 01:59]:
> Make sure ethernet and mdio nodes are disabled by default and enable
> them explicitly only on boards that actually use them.

Thanks applying into omap-for-v3.16/dt.

Tony
