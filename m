Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaDXR0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:26:24 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:53622 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933AbaDXR0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140424164445.GA4675@omega>
References: <1398193438-23805-1-git-send-email-mcgrof@do-not-panic.com> <20140424164445.GA4675@omega>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 24 Apr 2014 10:25:58 -0700
X-Google-Sender-Auth: z320ahSTzOf3hW_jvmSBgSJZquw
Message-ID: <CAB=NE6XS9-Zu9sb5geO2WTnnvv6KqyT+QnL5bRf1fiRx3=ocrg@mail.gmail.com>
Subject: Re: [Linux-zigbee-devel] [PATCH] 6lowpan: nuke net_ieee802154_lowpan()
 accessor when 6lowpan is disabled
To: Alexander Aring <alex.aring@gmail.com>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 9:44 AM, Alexander Aring <alex.aring@gmail.com> wrote:
> Hi,
>
> On Tue, Apr 22, 2014 at 12:03:58PM -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> Johannes noted this is not needed, all of the fragment
>> accessors don't need CONFIG_NET_NS. This goes test compiled with
>> CONFIG_BT_6LOWPAN=y and a disabled CONFIG_NET_NS.
>>
>
> a little note about this here. There exists two 6LoWPAN standard. One
> for bluetooth low energy and one for IEEE 802.15.4.
>
> The actual namespace is only for IEEE 802.15.4, because we need
> fragmentation there. 6LoWPAN fragmentation for bluetooth low energy is
> already handled by the MAC-Layer. So this has nothing to do with
> CONFIG_BT_6LOWPAN.

Thanks for the clarification, I actually did mean
CONFIG_IEEE802154_6LOWPAN however, I goofed that on the commit log.

  Luis
