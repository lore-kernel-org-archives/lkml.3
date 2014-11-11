Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKKKdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:33:31 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53408 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaKKKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:33:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="50579821"
From: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
To: Arend Van Spriel <arend@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>
Subject: RE: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
Thread-Topic: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
Thread-Index: Ac/9dB5NQ/C7C5zZRjSxY4lVQnUv+gAYOkKAAADe7IAAD69CoA==
Date: Tue, 11 Nov 2014 10:33:29 +0000
Message-ID: <DF163EE1A432BF4BBE6B2088220663A6743C05@SJEXCHMB06.corp.ad.broadcom.com>
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
 <1415698161.2163.0.camel@sipsolutions.net> <5461DCC9.5050702@broadcom.com>
In-Reply-To: <5461DCC9.5050702@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sABAXapc002594

Thanks a lot  Johannes and Arend , for your comments and review .
It will really help me in my next patch submission .

Just wanted to know when QCA patch will get in main line as it was  last updated on  23 aug 2012.


Thanks and regards

-----Original Message-----
From: Arend van Spriel [mailto:arend@broadcom.com] 
Sent: Tuesday, November 11, 2014 3:24 PM
To: Johannes Berg; Gautam (Gautam Kumar) Shukla
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; davem@davemloft.net; linux-api@vger.kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Jithu Jance; Sreenath S
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct cfg80211_connect_params needed for offloading 4way handshake to driver

On 11-11-14 10:29, Johannes Berg wrote:
> On Tue, 2014-11-11 at 05:56 +0000, Gautam (Gautam Kumar) Shukla wrote:
>> For offloading 4 way handshake to driver, currently we don't have any 
>> member  of struct cfg80211_connect_params to pass PSK from supplicant 
>> to driver. I have added psk for the same and added rest of the code 
>> needed in nl80211.h and nl80211.c to parse and make it available to 
>> driver.
>> From supplicant, we already have psk member field in assoc_params to 
>> use .
>>
>> Tested on x86 linux.
> 
> Your commit message needs serious work.
> 
> Also, there's a competing approach from QCA that's far more suited.

I probably was not paying attention to it, but would you have a reference to this.

> In either case though, I'm going to ask which driver is going to use 
> this and when it's going to land in mainline.

I had the same question ;-)

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
