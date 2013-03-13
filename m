Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab3CMRvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:51:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16672 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933132Ab3CMRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:51:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+G7Rd5j1RIY12M0yKhQ61BvyNzw+F+6lY=
Date: Wed, 13 Mar 2013 13:50:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH] pinctrl: mvebu: prevent walking off the end of group
 array
Message-ID: <20130313175053.GQ12700@titan.lakedaemon.net>
References: <1362872371.3690.106.camel@shinybook.infradead.org>
 <1363196155-1620-1-git-send-email-jason@lakedaemon.net>
 <CACRpkdaoF-PqqOi3bCQXnuey_2U+niHA8RWriXiJUE=kUZB0dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaoF-PqqOi3bCQXnuey_2U+niHA8RWriXiJUE=kUZB0dQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 06:47:36PM +0100, Linus Walleij wrote:
> On Wed, Mar 13, 2013 at 6:35 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > From: David Woodhouse <dwmw2@infradead.org>
> >
> > While investigating (ab)use of krealloc, David found this bug.  It's
> > unlikely to occur, but now we detect the condition and error out
> > appropriately.
> >
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> > David, please double check that this is as you intended.  I had to hand-jam it in due to some peculiarities on my side.
> 
> I have tentatively applied this to my fixes branch.

Dang, you're quick.  Please see V2 <shuffles feet>

thx,

Jason.
