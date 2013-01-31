Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3AaQ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:29:35 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:52823 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3AaQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:29:34 -0500
Date: Thu, 31 Jan 2013 16:29:33 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Afzal Mohammed <afzal@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 4/4] ARM: AM33XX: clock: SET_RATE_PARENT in lcd path
In-Reply-To: <alpine.DEB.2.00.1301311625290.32145@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1301311628430.32145@utopia.booyaka.com>
References: <cover.1358871018.git.afzal@ti.com> <24c9e4241b2988e66abd053508991d96cac964b7.1358871018.git.afzal@ti.com> <alpine.DEB.2.00.1301311625290.32145@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Paul Walmsley wrote:

> This one doesn't apply for me on v3.8-rc5 + your patches 2 and 3.  Could 
> you please update it and re-send?

Oops, looks like I accidentally tried to apply the first version of this 
patch rather than the second one.  The second one applies cleanly, so it's 
queued now for 3.9.


- Paul
