Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3GHJLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:11:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37985 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719Ab3GHJLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:11:05 -0400
X-Sasl-enc: OtI41ON+TDkVRyuAWR91Wk9ejTNWmnB9oYe07ITYgwVj 1373274663
Message-ID: <1373274660.2278.26.camel@perseus.fritz.box>
Subject: Re: [RFC PATCH 7/7] autofs - change CONFIG_AUTOFS4_FS to
 CONFIG_AUTOFS_FS
From: Ian Kent <raven@themaw.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 08 Jul 2013 17:11:00 +0800
In-Reply-To: <20130708151023.f29446059a3161fc2e8c9b2d@canb.auug.org.au>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
	 <20130701031449.4423.58614.stgit@perseus.fritz.box>
	 <20130701143924.79f57e7206577a2e7777c0a2@canb.auug.org.au>
	 <1373017884.2497.10.camel@perseus.fritz.box>
	 <20130708151023.f29446059a3161fc2e8c9b2d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 15:10 +1000, Stephen Rothwell wrote:
> Hi Ian,
> 
> On Fri, 05 Jul 2013 17:51:24 +0800 Ian Kent <raven@themaw.net> wrote:
> >
> > On Mon, 2013-07-01 at 14:39 +1000, Stephen Rothwell wrote:
> > > 
> > > On Mon, 01 Jul 2013 11:14:51 +0800 Ian Kent <raven@themaw.net> wrote:
> > > >
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > 
> > > Please don't do this.  Find a simple way to make sure that if
> > > CONFIG_AUTOFS4_FS is set, then "make oldconfig"  (or equivalent) will
> > > cause CONFIG_AUTOFS_FS to be set the same.
> > 
> > I get what your recommending but still can't think of a way to do it,
> > any thoughts?
> 
> Isn't just having
> 
> config AUTOFS4_FS
> 	tristate
> 	select AUTOFS_FS

I though that would set AUTOFS_FS=y unconditionally which I think is not
necessarily the setting that is needed. Also, I believe there's no way
to set it based on AUTOFS4_FS after it's value has been set from the
menu.
 
Ian


