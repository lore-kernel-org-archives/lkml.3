Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3BKIHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:07:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48703 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751Ab3BKIHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:07:22 -0500
Message-ID: <1360570041.2028.18.camel@joe-AO722>
Subject: Re: [PATCH] wlcore: remove newly introduced alloc/OOM messages
From: Joe Perches <joe@perches.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Date: Mon, 11 Feb 2013 00:07:21 -0800
In-Reply-To: <1360569749-28372-1-git-send-email-coelho@ti.com>
References: <1360569218.12803.50.camel@cumari.coelho.fi>
	 <1360569749-28372-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
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

You sure?

The largish patch doesn't match the commit message.

