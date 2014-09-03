Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaICVr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:47:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31922 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaICVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:47:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NilyotyhcULbuQ85kmqhJ
Date: Wed, 3 Sep 2014 14:47:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: am437x-gp: switch i2c0 to 100KHz
Message-ID: <20140903214715.GO11766@atomide.com>
References: <1409769981-17669-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409769981-17669-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140903 11:46]:
> On the GP EVM, the ambient light sensor is limited to 100KHz on the
> I2C bus.
> 
> So use 100kHz for I2C on the GP EVM due to this limitation on the
> ambient light sensor.
> 
> Reported-by: Aparna Balasubramanian <aparnab@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Thanks applying into omap-for-v3.7/fixes-v2.

Tony
