Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3JIHMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:12:39 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:39303 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3JIHMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:12:37 -0400
Date: Wed, 9 Oct 2013 07:12:36 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 9/9] ARM: AM33xx: hwmod_data: add the sysc configuration
 for spinlock
In-Reply-To: <760966ea7566835b151043bf1d806803c8b9f9c8.1379445653.git.s-anna@ti.com>
Message-ID: <alpine.DEB.2.02.1310090711420.30199@utopia.booyaka.com>
References: <cover.1379445653.git.s-anna@ti.com> <760966ea7566835b151043bf1d806803c8b9f9c8.1379445653.git.s-anna@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Suman Anna wrote:

> Add the missing sysc configuration to the AM335 spinlock hwmod
> data. This ensures that smart-idle is enabled whenever the module
> is enabled by the driver.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>

Thanks, queued.  You can omit this one from future reposts of this series.

- Paul
