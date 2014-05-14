Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaENVTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:19:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50049 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752265AbaENVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:19:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cHV4pjTLph/pR1+0lrztG
Date: Wed, 14 May 2014 14:18:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, george.cherian@ti.com, balbi@ti.com, balajitk@ti.com,
        hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v5 4/4] ARM: dts: dra7: add OCP2SCP3 and SATA nodes
Message-ID: <20140514211851.GF27426@atomide.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
 <1398274575-24818-1-git-send-email-rogerq@ti.com>
 <536A2002.4020603@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A2002.4020603@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140507 04:59]:
> From: Balaji T K <balajitk@ti.com>
> 
> Add nodes for OCP2SCP3 bus, SATA controller and SATA PHY.
> 
> [Roger Q] Clean up. Updated IRQ for interrupt crossbar.

Adding this too into omap-for-v3.16/dt.

Regards,

Tony
