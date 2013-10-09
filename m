Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3JIFnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:43:16 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:38839 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3JIFnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:43:14 -0400
Date: Wed, 9 Oct 2013 05:43:13 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Sebastian Reichel <sre@debian.org>
cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?ISO-8859-15?Q?'Beno=EEt_Cousson'?=" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "=?ISO-8859-15?Q?'Pali_Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?KOI8-R?B?J+nXwcrMzyDkyc3J1NLP1yc=?= <freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [RFCv3 1/7] ARM: OMAP2+: hwmod-data: Add SSI information
In-Reply-To: <1381091235-18293-2-git-send-email-sre@debian.org>
Message-ID: <alpine.DEB.2.02.1310090542270.30199@utopia.booyaka.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org> <1381091235-18293-2-git-send-email-sre@debian.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Oct 2013, Sebastian Reichel wrote:

> This patch adds Synchronous Serial Interface (SSI) hwmod support for
> OMAP34xx SoCs.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Thanks, queued this one for v3.13.  You can drop it from any future 
reposts of this series.


- Paul
