Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaEETbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:31:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14092 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaEETbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:31:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+EVivOT/q5sjSms60HxOX+
Date: Mon, 5 May 2014 12:31:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 00/14] OMAP SSI driver / N900 modem support
Message-ID: <20140505193129.GC25949@atomide.com>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [140328 17:36]:
> Please send feedback (e.g. Tested-By or Reviewed-By :)), so that I can
> send a pull request for 3.16. You can either apply this patchset or
> use the n900-modem-support branch available on [1].

Sebastian, can you please do a separate pull request for the .dts
changes for me once the driver changes are pulled? Otherwise we
will be creating pointless merge conflicts.

Regards,

Tony
