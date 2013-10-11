Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3JKXjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:39:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48868 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3JKXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:39:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19roJkrjHSBPMUTfuXZHpKB
Date: Fri, 11 Oct 2013 16:39:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: N900: TWL4030 Keypad Matrix definition
Message-ID: <20131011233935.GF29913@atomide.com>
References: <1381353447-32708-1-git-send-email-sre@debian.org>
 <1381353447-32708-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381353447-32708-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131009 14:26]:
> Add Keyboard Matrix information to N900's DTS file.
> This patch maps the keys exactly as the original
> board code.

This should be queued by Benoit along with other .dts
changes, not via the input tree:

Acked-by: Tony Lindgren <tony@atomide.com>
