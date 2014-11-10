Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaKJRwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:52:03 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaKJRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:52:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XnYBy2cEGfgqd43efwU4j
Date: Mon, 10 Nov 2014 09:51:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH] ARM: dts: omap3-gta04: Use omap specific pinctrl defines
Message-ID: <20141110175104.GQ31454@atomide.com>
References: <1413577923-23526-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413577923-23526-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [141017 13:33]:
> Use omap specific pinctrl defines (OMAP3_CORE1_IOPAD) to configure
> the padconf register offset.

Thanks applying into omap-for-v3.19/dt.

Tony
