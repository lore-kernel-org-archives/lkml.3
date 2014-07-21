Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaGUJkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:40:31 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:45014 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaGUJka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:40:30 -0400
Message-ID: <1405935610.32255.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v7 08/33] net: nl80211 - make rdev_add_virtual_intf take
 name_assign_type
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        John Linville <linville@tuxdriver.com>
Date: Mon, 21 Jul 2014 11:40:10 +0200
In-Reply-To: <1404980258-30853-9-git-send-email-teg@jklm.no> (sfid-20140710_101817_648059_1F1D29C5)
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	 <1404980258-30853-9-git-send-email-teg@jklm.no>
	 (sfid-20140710_101817_648059_1F1D29C5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 10:17 +0200, Tom Gundersen wrote:
> Pass the value down and set it at the same place the name itself is set.

Is this going to be applied as part of one bigger series?

johannes

