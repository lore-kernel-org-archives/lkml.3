Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3AYIo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:44:57 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:41639 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3AYIoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:44:54 -0500
Date: Fri, 25 Jan 2013 08:44:53 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Afzal Mohammed <afzal@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 2/4] ARM: OMAP2+: dpll: am335x - avoid freqsel
In-Reply-To: <b0be0227b6b07a8c16b13a06fe500694c751827c.1358871018.git.afzal@ti.com>
Message-ID: <alpine.DEB.2.00.1301250844430.471@utopia.booyaka.com>
References: <cover.1358871018.git.afzal@ti.com> <b0be0227b6b07a8c16b13a06fe500694c751827c.1358871018.git.afzal@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Afzal Mohammed wrote:

> am335x does not have freqsel, avoid it.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>

Thanks, queued for 3.9.

- Paul
