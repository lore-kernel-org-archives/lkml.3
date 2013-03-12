Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3CLNci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:32:38 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:24035 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753611Ab3CLNcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:32:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/N58qu8Ex0N4EqWdhjZiVc4pHx0v/r9f4=
Date: Tue, 12 Mar 2013 09:32:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-ID: <20130312133225.GG12700@titan.lakedaemon.net>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
 <CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com>
 <20130312115339.GF12700@titan.lakedaemon.net>
 <201303121248.24736.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303121248.24736.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:48:24PM +0000, Arnd Bergmann wrote:
> On Tuesday 12 March 2013, Jason Cooper wrote:
> > I chose to keep them together to maintain bisectability.  Either you
> > have all of the fix (you landed on this branch), or you don't.  Was this
> > the correct decision in this case, or did I miss something?
> 
> I think you don't need to worry about bisection in this case, especially
> as you mentioned that 3.8 is already broken.
> 
> From all I can tell, these are four separate fixes, and you want to have
> all of them get merged, but applying just one of them will not make the
> state of the kernel tree any worse than what it is before the patches.

Ok, thanks for the clarification.  I'll ease up on the bisectability
requirement for fixes in the future.

thx,

Jason.
