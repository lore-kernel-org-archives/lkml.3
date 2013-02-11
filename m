Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3BKIIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:08:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52969 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab3BKIIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:08:45 -0500
Message-ID: <1360570053.12803.52.camel@cumari.coelho.fi>
Subject: Re: [PATCH] wlcore: remove newly introduced alloc/OOM messages
From: Luciano Coelho <coelho@ti.com>
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
Date: Mon, 11 Feb 2013 10:07:33 +0200
In-Reply-To: <1360570041.2028.18.camel@joe-AO722>
References: <1360569218.12803.50.camel@cumari.coelho.fi>
	 <1360569749-28372-1-git-send-email-coelho@ti.com>
	 <1360570041.2028.18.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 00:07 -0800, Joe Perches wrote:
> On Mon, 2013-02-11 at 10:02 +0200, Luciano Coelho wrote:
> > In commit 0d2e7a5c (wireless: Remove unnecessary alloc/OOM messages,
> > alloc cleanups) OOM messages after alloc were removed from the wlcore
> > modules.
> > 
> > Commit afb43e6d (wlcore: remove if_ops from platform_data)
> > reintroduced a couple of those.  This patch removes them.
> 
> You sure?
> 
> The largish patch doesn't match the commit message.

Sorry, I screwed up.  I'll send v2 in a second (should get some more
coffee first ;)

--
Luca.

