Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaI3Hi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:38:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3Hi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:38:57 -0400
Date: Tue, 30 Sep 2014 00:38:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, Randy Dunlap <rdunlap@infradead.org>,
        Michael Elizabeth Chastain <mec@shout.net>,
        Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] description and restrictions of _shipped
Message-ID: <20140930073829.GA32613@infradead.org>
References: <20140928175513.GA5517@opentech.at>
 <1411928181.21874.19.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411928181.21874.19.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:16:21AM -0700, Joe Perches wrote:
> *_shipped files are not just binary.
> 
> Perhaps these are better described as "auto-generated" files.

The use case for them is to ship generated files that require tools we
don't want to require for "just" a kernel build.  The only exception
is ./drivers/net/wan/wanxlfw.inc_shipped, which really should use
the firmware loader instead, or given that the driver has seen no
work since git history probably just be removed.

So please remove the bullshit language that seems to imply allowing to ship
binaries code, and resend the patch.

