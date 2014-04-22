Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaDVJpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:45:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:41438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaDVJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:45:08 -0400
Message-ID: <1398159886.4211.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/3] 6lowpan: add helper to get 6lowpan namespace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 22 Apr 2014 11:44:46 +0200
In-Reply-To: <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20140418_032412_117495_4585013B)
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
	 <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140418_032412_117495_4585013B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-17 at 18:22 -0700, Luis R. Rodriguez wrote:

> +#if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
> [...]
> +#else
> +static inline struct netns_ieee802154_lowpan *
> +net_ieee802154_lowpan(struct net *net)
> +{
> +	return NULL;
> +}
> +#endif

Why would that be needed? If nobody compiles 802.15.4 then it seems
nothing should reference it?

johannes

