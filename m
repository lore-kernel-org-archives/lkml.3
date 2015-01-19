Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbASUbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:31:50 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58209 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbbASUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:31:47 -0500
Date: Mon, 19 Jan 2015 12:31:43 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call
 "iounmap"
Message-ID: <20150119203143.GL9759@ld-irv-0074>
References: <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54BBE87C.9020705@users.sourceforge.net>
 <20150119175835.GH9759@ld-irv-0074>
 <54BD4AB6.70708@users.sourceforge.net>
 <20150119183057.GI9759@ld-irv-0074>
 <54BD55F6.6090609@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BD55F6.6090609@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 08:07:34PM +0100, SF Markus Elfring wrote:
> >> I published scripts for static source code analysis in March 2004.

^^ That would be March 2014, not March 2004.

> > I didn't ask "when?"; where?
> 
> https://lkml.org/lkml/2014/3/5/356
> http://article.gmane.org/gmane.comp.version-control.coccinelle/3513/
> https://systeme.lip6.fr/pipermail/cocci/2014-March/000676.html
> 
> Do you get further ideas from this software analysis approach?

I suppose. I've gotten the idea that I can generate a ton of patches
using an automated tool, not test or research them, possibly add bugs to
the kernel, and still get a good percentage of my patches merged.

Now, have *you* learned anything from this approach?

Brian
