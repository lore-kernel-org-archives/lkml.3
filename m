Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3HEQwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:52:17 -0400
Received: from tex.lwn.net ([70.33.254.29]:38468 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3HEQwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:52:16 -0400
Date: Mon, 5 Aug 2013 10:52:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
Message-ID: <20130805105214.14b77ced@lwn.net>
In-Reply-To: <alpine.DEB.2.02.1308051810360.2134@hadrien>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
	<1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
	<20130805160645.GI5051@mwanda>
	<alpine.DEB.2.02.1308051810360.2134@hadrien>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Aug 2013 18:19:18 +0200 (CEST)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> Oops, thanks for spotting that.  I'm not sure whether it is safe to abort 
> these calls as soon as the first one fails, but perhaps I could introduce 
> some more variables, and test them all afterwards.

Yes, it would be safe.  But it's hard to imagine a scenario where any of
those particular calls would fail that doesn't involve smoke.

The code is evidence of ancient laziness on my part.  I'll add fixing it
up to my list of things to do.

Thanks,

jon
