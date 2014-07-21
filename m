Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbaGURD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:03:26 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:38467 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbaGURDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:03:25 -0400
MIME-Version: 1.0
X-Originating-IP: [84.49.232.147]
In-Reply-To: <1405935610.32255.5.camel@jlt4.sipsolutions.net>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-9-git-send-email-teg@jklm.no> <1405935610.32255.5.camel@jlt4.sipsolutions.net>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 21 Jul 2014 19:03:04 +0200
Message-ID: <CAG-2HqVhQKQXO-7AHa2y+YfEPco2z1-QvyzoGOThADoLVxVVFg@mail.gmail.com>
Subject: Re: [PATCH v7 08/33] net: nl80211 - make rdev_add_virtual_intf take name_assign_type
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Mon, Jul 21, 2014 at 11:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-07-10 at 10:17 +0200, Tom Gundersen wrote:
>> Pass the value down and set it at the same place the name itself is set.
>
> Is this going to be applied as part of one bigger series?

This patch is superceded by "[PATCH net-next v9 2/9] net: nl80211 -
make rdev_add_virtual_intf take name_assign_type", which indeed is
part of a bigger series.

However, if you and David prefer to take it through your tree, let me
know and I'll split it out from the series and resubmit it to you
independently.

Cheers,

Tom
