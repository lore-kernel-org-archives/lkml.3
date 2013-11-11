Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3KKXe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:34:58 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41289 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3KKXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:34:53 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ChIpubHhq3kEAnFOAxH/S
Date: Mon, 11 Nov 2013 15:34:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Message-ID: <20131111233426.GS15154@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <1381784555-18344-2-git-send-email-marek@goldelico.com>
 <20131111164917.GN15154@atomide.com>
 <CAAfyv34CyviSt_Jaygr-CYSQdZOBHz14awT3U8=2ZBT14s896g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv34CyviSt_Jaygr-CYSQdZOBHz14awT3U8=2ZBT14s896g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Belisko Marek <marek.belisko@gmail.com> [131111 14:21]:
> AFAIK it's not pinmux it's register where we update bits. Or am I
> missing something?

Most of the omap control module registers seem to affect either
external pin configuration or internal signal muxes. So a big
chunk of them can already be handled with pinctrl-single,bits
for device tree.

But some of the control module registers also have regulator
and clock like features, and those are better exposed as
regulators and clocks to the consumer drivers.

Regards,

Tony
