Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbbASSbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:31:04 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55013 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbASSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:31:01 -0500
Date: Mon, 19 Jan 2015 10:30:57 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call
 "iounmap"
Message-ID: <20150119183057.GI9759@ld-irv-0074>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54BBE87C.9020705@users.sourceforge.net>
 <20150119175835.GH9759@ld-irv-0074>
 <54BD4AB6.70708@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BD4AB6.70708@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 07:19:34PM +0100, SF Markus Elfring wrote:
> > Anyway, I'm essentially saying that I'd like to be 100% sure we have a
> > guarantee before dropping all these.
> 
> You can not be absolutely sure. There are various implementation details
> which will eventually need further considerations.

Let's consider them first. We don't ship code that is missing the
implementation details. (At least, we try not to!)

> I hope that a reasonable confidence can be achieved here.
> 
> 
> >> This issue was detected by using the Coccinelle software.
> > 
> > What script?
> 
> I published scripts for static source code analysis in March 2004.

I didn't ask "when?"; where?

> > Hand-rolled I guess?
> 
> An extended version found some update candidates in source files for Linux
> according to the software development status of "next-20141226".
> 
> My approach is still incomplete at the moment.

Then please complete it.

Thanks,
Brian
