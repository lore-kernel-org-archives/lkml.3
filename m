Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaL0Tzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 14:55:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:4645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaL0Tzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 14:55:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,652,1413270000"; 
   d="scan'208";a="661148998"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 12/27] iwlwifi: dvm: main: Use setup_timer
Thread-Topic: [PATCH 12/27] iwlwifi: dvm: main: Use setup_timer
Thread-Index: AQHQIRovO/LD1lb0LEidp+FL/nBrxpyjuluA
Date: Sat, 27 Dec 2014 19:55:21 +0000
Message-ID: <1419710121.6140.0.camel@egrumbacBox>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1419604558-29743-14-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1419604558-29743-14-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.170.105]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6429DB7FDB9FEA4FBEDA201ED9B82ADC@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBRJuBcu013518

On Fri, 2014-12-26 at 15:35 +0100, Julia Lawall wrote:
> Convert a call to init_timer and accompanying intializations of
> the timer's data and function fields to a call to setup_timer.
> 
> A simplified version of the semantic match that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression t,f,d;
> @@
> 
> -init_timer(&t);
> +setup_timer(&t,f,d);
> -t.data = d;
> -t.function = f;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 

Both applied - thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
