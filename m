Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaDVSpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:45:44 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:43550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaDVSpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:45:40 -0400
Message-ID: <1398192315.4211.25.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/3] 6lowpan: add helper to get 6lowpan namespace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Alexander Aring <alex.aring@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org
Date: Tue, 22 Apr 2014 20:45:15 +0200
In-Reply-To: <20140422175818.GN27882@wotan.suse.de>
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
	 <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com>
	 <1398159886.4211.1.camel@jlt4.sipsolutions.net>
	 <20140422095300.GA9241@omega> <20140422175818.GN27882@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 19:58 +0200, Luis R. Rodriguez wrote:

> > > > +#if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
> > > > [...]
> > > > +#else
> > > > +static inline struct netns_ieee802154_lowpan *
> > > > +net_ieee802154_lowpan(struct net *net)
> > > > +{
> > > > +	return NULL;
> > > > +}
> > > > +#endif
> > > 
> > > Why would that be needed? If nobody compiles 802.15.4 then it seems
> > > nothing should reference it?
> > > 
> > Indeed I think this is unnecessary, also.
> 
> I wanted to be sure, and I was not. Right now 6lowpan does not depend
> on CONFIG_NET_NS, is this intentional? I think its fine without it
> but I was not sure.

I fail to see how !CONFIG_LOWPAN is related CONFIG_NET_NS?

johannes

