Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaDVJxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:53:14 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44856 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaDVJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:53:11 -0400
Date: Tue, 22 Apr 2014 11:53:03 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH 1/3] 6lowpan: add helper to get 6lowpan namespace
Message-ID: <20140422095300.GA9241@omega>
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
 <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com>
 <1398159886.4211.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398159886.4211.1.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 22, 2014 at 11:44:46AM +0200, Johannes Berg wrote:
> On Thu, 2014-04-17 at 18:22 -0700, Luis R. Rodriguez wrote:
> 
> > +#if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
> > [...]
> > +#else
> > +static inline struct netns_ieee802154_lowpan *
> > +net_ieee802154_lowpan(struct net *net)
> > +{
> > +	return NULL;
> > +}
> > +#endif
> 
> Why would that be needed? If nobody compiles 802.15.4 then it seems
> nothing should reference it?
> 
Indeed I think this is unnecessary, also.

- Alex
