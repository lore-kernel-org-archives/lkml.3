Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3FUGxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:53:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62343 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab3FUGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:53:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Mu0qZTUYwi3xFp2lMupXE
Date: Thu, 20 Jun 2013 23:53:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Message-ID: <20130621065310.GK5523@atomide.com>
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
 <20130621164149.598b39bb78b6015057d03f6f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621164149.598b39bb78b6015057d03f6f@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [130620 23:48]:
> Hi all,
> 
> On Fri, 21 Jun 2013 16:26:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > drivers/mailbox/Kconfig between commit a1824eaab70f ("mailbox: OMAP:
> > introduce mailbox framework") from the mailbox tree and commit
> > c869c75c16b3 ("mailbox/omap: move the OMAP mailbox framework to drivers")
> > from the arm-soc tree.
> > 
> > I fixed it up (I suspect not properly - see below) and can carry the fix
> > as necessary (no action is required).
> > 
> > It looks like we have two different versions of these changes in
> > linux-next now, so please clean it all up.  i.e. can I just drop the
> > mailbox tree now?
> 
> OK, things went steeply downhill from here, so I went back and removed
> the mailbox tree ...

I think Olof dropped the earlier version of the mailbox branch, and
remerged the updated mailbox branch. So if there was also yet another
mailbox branch being pulled into Linux next, then yes, dropping it is
the way to go.

Regards,

Tony
