Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3EGJQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:16:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:53572 "EHLO
	sipsolutions.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759277Ab3EGJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:16:13 -0400
Message-ID: <1367918136.8328.1.camel@jlt4.sipsolutions.net>
Subject: Re: linux-next: Tree for May 6 (b43/bcma)
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev@lists.infradead.org
Date: Tue, 07 May 2013 11:15:36 +0200
In-Reply-To: <51886FAF.1030801@lwfinger.net> (sfid-20130507_051212_785834_D4BC17E9)
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
	 <5187EB95.2060605@infradead.org> <51886FAF.1030801@lwfinger.net>
	 (sfid-20130507_051212_785834_D4BC17E9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 22:06 -0500, Larry Finger wrote:

> > Probably mostly due to B43=y and BCMA=m.
> 
> Does any Kconfig wizard know the magic incantation to accomplish the following:
> 
> 1. Ensure that if SSB and BMCA are both selected, then both are either "m" or "y"

I think one of them being m and the other y should be OK? But do they
have interdependencies?

> 2. Ensure that BRCMSMAC is not "y" if BMCA is "m".

Isn't that a simple
	depends on BCMA
or maybe it can work w/o BCMA, then you'd have
	depends on BCMA || !BCMA

> 3. Ensure that B43 is not "y" if SSB and/or BCMA is "m".

same.

johannes

