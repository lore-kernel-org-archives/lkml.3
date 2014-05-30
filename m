Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaE3Oii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:38:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34771 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaE3Oih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:38:37 -0400
Date: Fri, 30 May 2014 07:38:34 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?ISO-8859-1?B?TPxzc2luZw==?= <linus.luessing@web.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv2 net-next 3/4] bridge: add export of multicast database
 adjacent to net_dev
Message-ID: <20140530073834.0986af33@nehalam.linuxnetplumber.net>
In-Reply-To: <1400994205-31165-4-git-send-email-linus.luessing@web.de>
References: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
	<1400994205-31165-4-git-send-email-linus.luessing@web.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2014 07:03:24 +0200
Linus Lüssing <linus.luessing@web.de> wrote:

> With this new, exported function br_multicast_list_adjacent(net_dev) a
> list of IPv4/6 addresses is returned. This list contains all multicast
> addresses sensed by the bridge multicast snooping feature on all bridge
> ports of the bridge interface of net_dev, excluding addresses from the
> specified net_device itself.
> 
> Adding bridge support to the batman-adv multicast optimization requires
> batman-adv knowing about the existence of bridged-in multicast
> listeners to be able to reliably serve them with multicast packets.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Please use EXPORT_SYMBOL_GPL
