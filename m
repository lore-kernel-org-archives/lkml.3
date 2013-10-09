Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3JIHMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:12:54 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:39322 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3JIHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:12:52 -0400
Date: Wed, 9 Oct 2013 07:12:51 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 4/9] ARM: OMAP5: hwmod data: Add spinlock data
In-Reply-To: <9812d9a19f9a52021dcae4b4fef50f10f2c21202.1379445653.git.s-anna@ti.com>
Message-ID: <alpine.DEB.2.02.1310090712440.30199@utopia.booyaka.com>
References: <cover.1379445653.git.s-anna@ti.com> <9812d9a19f9a52021dcae4b4fef50f10f2c21202.1379445653.git.s-anna@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Suman Anna wrote:

> Add the hwmod data for the spinlock IP in OMAP5 SoC.
> This is needed to be able to enable the OMAP spinlock
> support for OMAP5.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>

Thanks, queued.  You can omit this one from future reposts of this series.



- Paul
