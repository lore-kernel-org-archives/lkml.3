Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaGQJXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:23:20 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:53127 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbaGQJXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:23:18 -0400
Message-ID: <1405588986.20120.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH net-next v9 2/9] net: nl80211 - make
 rdev_add_virtual_intf take name_assign_type
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Date: Thu, 17 Jul 2014 11:23:06 +0200
In-Reply-To: <CAG-2HqWGVqNFJGeh_Uj2pbC-+m8tsHeeO=f_3MD8JMcTDvpDDw@mail.gmail.com> (sfid-20140717_111719_497030_C610CFFC)
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
	 <1405584370-30054-3-git-send-email-teg@jklm.no>
	 <1405587855.20120.0.camel@jlt4.sipsolutions.net>
	 <CAG-2HqWGVqNFJGeh_Uj2pbC-+m8tsHeeO=f_3MD8JMcTDvpDDw@mail.gmail.com>
	 (sfid-20140717_111719_497030_C610CFFC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 11:16 +0200, Tom Gundersen wrote:

> >>  static struct wireless_dev *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
> >>                                                     const char *name,
> >> +                                                   unsigned char name_assign_type,
> >
> > unsigned char for an enum is really odd.
> 
> Hm, this was based on the addr_assign_type attribute, which also is an
> unsigned char (and serves a very similar purpose).
> 
> Out of interest, what would you have preferred (and why)?

Even if it eventually ends up being assigned to a u8 or something, it
seems passing it around as an enum makes the interfaces better?

johannes

