Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaGQJEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:04:40 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:53041 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbaGQJEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:04:35 -0400
Message-ID: <1405587855.20120.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH net-next v9 2/9] net: nl80211 - make
 rdev_add_virtual_intf take name_assign_type
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, John Linville <linville@tuxdriver.com>
Date: Thu, 17 Jul 2014 11:04:15 +0200
In-Reply-To: <1405584370-30054-3-git-send-email-teg@jklm.no> (sfid-20140717_101259_938095_1A8DB91D)
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
	 <1405584370-30054-3-git-send-email-teg@jklm.no>
	 (sfid-20140717_101259_938095_1A8DB91D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 10:06 +0200, Tom Gundersen wrote:
> Pass the value down and set it at the same place the name itself is set.

Huh? What's this? Can you explain why?

>  static struct wireless_dev *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
>  						      const char *name,
> +						      unsigned char name_assign_type,

unsigned char for an enum is really odd.

johannes


