Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3BKIH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:07:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40440 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3BKIH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:07:57 -0500
Message-ID: <1360570003.12803.51.camel@cumari.coelho.fi>
Subject: Re: [PATCH] wlcore: remove newly introduced alloc/OOM messages
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <sfr@canb.auug.org.au>, <joe@perches.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Date: Mon, 11 Feb 2013 10:06:43 +0200
In-Reply-To: <1360569749-28372-1-git-send-email-coelho@ti.com>
References: <1360569218.12803.50.camel@cumari.coelho.fi>
	 <1360569749-28372-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 10:02 +0200, Luciano Coelho wrote:
> In commit 0d2e7a5c (wireless: Remove unnecessary alloc/OOM messages,
> alloc cleanups) OOM messages after alloc were removed from the wlcore
> modules.
> 
> Commit afb43e6d (wlcore: remove if_ops from platform_data)
> reintroduced a couple of those.  This patch removes them.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
> 
> John,
> 
> Can you apply this directly on wireless-next after you process my latest pull-request?
> 
> Thanks!

Ermm... obviously this is completely wrong.  I'll send v2 in a bit.

--
Luca.

