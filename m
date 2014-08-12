Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaHLIoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:44:17 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:60977 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaHLIoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <70001DBA-E1CE-49D6-9A37-6F7CE31B61E6@holtmann.org>
References: <1407780269.28221.63.camel@chimera> <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org>
 <1407789645.28221.68.camel@chimera> <37210DB5-2911-4FA3-9299-7701C5003945@holtmann.org>
 <1407791075.28221.74.camel@chimera> <28066DB2-9EA9-4748-9C89-D3FBD3EC51F5@holtmann.org>
 <1407798738.28221.81.camel@chimera> <52896C9C-8560-4CE4-A1FB-C896D766EC87@holtmann.org>
 <1407801666.28221.84.camel@chimera> <70001DBA-E1CE-49D6-9A37-6F7CE31B61E6@holtmann.org>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 12 Aug 2014 10:43:27 +0200
Message-ID: <CAOiHx=mWkvOf=An=TzWDidK2o4+KGQmz8MAHNo3rSuwbBzUWEg@mail.gmail.com>
Subject: Re: [PATCH] allow setting wiphy.perm_addr after driver probe
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 9:59 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Daniel,
>
>>> the way I read the nl80211 code is that the NL80211_CMD_NEW_INTERFACE
>>> requires a wiphy device to be specified. And that is actually just a
>>> number. So I have no idea what the MAC has to here.
>>>
>> OpenWrt finds a wiphy by its MAC.
>
> maybe that is the first problem right there. I see that over sysfs you get phy80211/macaddress. However if you do a dump via NL80211_CMD_GET_WIPHY then you do not have the MAC address there.

OpenWrt nowadays uses the device path in sysfs/devices to identify
wiphys, not the mac anymore (e.g 'pci0000:00/0000:00:01.0/ssb0:0').


Jonas
