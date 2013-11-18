Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3KRCXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:23:43 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41641 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3KRCXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:23:35 -0500
MIME-Version: 1.0
In-Reply-To: <1384740932.5814.4.camel@joe-AO722>
References: <20131118020746.GX16018@ringworld.MIT.EDU>
	<1384740932.5814.4.camel@joe-AO722>
Date: Mon, 18 Nov 2013 00:23:33 -0200
Message-ID: <CAK4VdL0cnqCS6w8ad8ohidwVzjRc4ytokvA7a8jSo0HhDPef8Q@mail.gmail.com>
Subject: Re: [PATCH] Clarify error on directive in macro arguments (Re:
 [PATCH] jffs2: fix sparse errors: directive in argument list)
From: Erico Nunes <nunes.erico@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Price <price@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
        dwmw2 <dwmw2@infradead.org>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:15 AM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2013-11-17 at 21:07 -0500, Greg Price wrote:
>
> Maybe, but this case isn't a macro.  It's a function.
> Dunno if differentiating when it's a macro or a
> function is difficult though.
>
>

The case which was initially reported by sparse at
http://www.spinics.net/lists/kernel/msg1636974.html was using pr_info
(which is a macro) and not printk.
