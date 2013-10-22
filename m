Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3JVPLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:11:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26269 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3JVPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:11:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CB/Z73UaKKCTvEbtYrPpz
Date: Tue, 22 Oct 2013 08:11:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH V7 3/8] ARM: OMAP3+: use cpu0-cpufreq driver in device
 tree supported boot
Message-ID: <20131022151135.GN15154@atomide.com>
References: <1381937948-27057-1-git-send-email-nm@ti.com>
 <1381937948-27057-4-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381937948-27057-4-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131016 08:39]:
> With OMAP3+ and AM33xx supported SoC having defined CPU device tree
> entries with operating-points and clock nodes defined, we can now use
> the SoC generic cpufreq-cpu0 driver by registering appropriate device.

Thanks I'm taking patches 1 - 3 from this series into
omap-for-v3.13/board-removal-take2 because of the dependencies.

Tony
