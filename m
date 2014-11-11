Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaKKKft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:35:49 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41585 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaKKKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:35:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="50363081"
Message-ID: <5461E67E.7010408@broadcom.com>
Date: Tue, 11 Nov 2014 11:35:42 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>,
        Vladimir Kondratiev <vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct cfg80211_connect_params
 needed for offloading 4way handshake to driver
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>	 <1415698161.2163.0.camel@sipsolutions.net> <5461DCC9.5050702@broadcom.com> <1415700220.2163.3.camel@sipsolutions.net>
In-Reply-To: <1415700220.2163.3.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-14 11:03, Johannes Berg wrote:
> On Tue, 2014-11-11 at 10:54 +0100, Arend van Spriel wrote:
> 
>>> Also, there's a competing approach from QCA that's far more suited.
>>
>> I probably was not paying attention to it, but would you have a
>> reference to this.
> 
> ... digs around in email ...
> 
> http://mid.gmane.org/1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com
> 
> Anyway, looking back at that, it wasn't really all that different, just
> a bit more complete maybe.

Read through the whole thread. It seems some comments from you needed to
be addressed and Vladimir wanted to evaluate it. So that was the end of
the thread.

What did pop up is the wiphy flags vs. nl80211 feature flags. When that
comes up it looks like 'potAtoes, potaetoes' to me.

So is there are clear design rule for when to use which flag. For me the
wiphy object represents the device/firmware and 4-way handshake offload
support is determined by what the device/firmware supports.

Regards,
Arend

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

