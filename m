Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3AaQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:25:29 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:52751 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3AaQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:25:27 -0500
Date: Thu, 31 Jan 2013 16:25:26 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Afzal Mohammed <afzal@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3/4] ARM: OMAP2+: clock: DEFINE_STRUCT_CLK_FLAGS helper
In-Reply-To: <abe7aceb564b97ab00b88b13a9aac487363e01c1.1358871018.git.afzal@ti.com>
Message-ID: <alpine.DEB.2.00.1301311625120.32145@utopia.booyaka.com>
References: <cover.1358871018.git.afzal@ti.com> <abe7aceb564b97ab00b88b13a9aac487363e01c1.1358871018.git.afzal@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Afzal Mohammed wrote:

> DEFINE_STRUCT_CLK does not have the capability to set flags, define
> DEFINE_STRUCT_CLK_FLAGS to handle flags. This is needed to add
> SET_RATE_PARENT flag in statically defined lcd clock in am335x.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>

Thanks, queued for 3.9.


- Paul
