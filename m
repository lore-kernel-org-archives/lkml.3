Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3GYBre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:47:34 -0400
Received: from s15338416.onlinehome-server.info ([87.106.68.36]:37955 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GYBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:47:33 -0400
Date: Thu, 25 Jul 2013 03:47:32 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Joe Perches <joe@perches.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH - diffstat only] include/net: Remove extern from function prototypes
Message-ID: <20130725014732.GA10036@order.stressinduktion.org>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <1374602291.3387.17.camel@joe-AO722> <kspuuk$k2v$1@ger.gmane.org> <1374716480.1924.18.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374716480.1924.18.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:41:20PM -0700, Joe Perches wrote:
> On Thu, 2013-07-25 at 01:27 +0000, Cong Wang wrote:
> > On Tue, 23 Jul 2013 at 17:58 GMT, Joe Perches <joe@perches.com> wrote:
> 
> You dropped the author from the cc list.
> Always reply to the author.
> 
> > > Function prototypes don't need to be declared
> > > extern in .h files.  It's assumed by the compiler
> > > and is as unnecessary as using auto is when
> > > declaring automatic/local variables in a block.
> > >
> > Since we all know this, why bother it?
> 
> If everyone knew this, new ones wouldn't be added.
> But a lot are.

Couldn't checkpatch take care of these?

Greetings,

  Hannes
