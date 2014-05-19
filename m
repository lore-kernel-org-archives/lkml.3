Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaESWGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:06:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:15405 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaESWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,869,1392192000"; 
   d="scan'208";a="541719663"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Chen Yucong <slaoub@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH] x86/mce: Clear a useless global variable in mce.c
Thread-Topic: [PATCH] x86/mce: Clear a useless global variable in mce.c
Thread-Index: AQHPcciTwzLgOJZKAUyQ4CRuQRCpq5tIMhJggAB8UAD//8p3cA==
Date: Mon, 19 May 2014 22:06:38 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3280EA8A@ORSMSX114.amr.corp.intel.com>
References: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
 <20140519181524.GC6311@pd.tnic>
In-Reply-To: <20140519181524.GC6311@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4JM6khw007365

> I mean, does the machine even recover after some of the cores have gone
> into the weeds in #MC? Provided, of course, we don't have a no-way-out
> MCE and we can resume execution.

I doubt there is any hope for recovery if not all processors show up ... things
have to be already very broken for the machine check to be blocked.

> Or is the box so hammered that there's no turning back?

I think so.

> Concerning mce_entry, I don't care all that much - if it is really
> useful, you might slap a comment saying so and keep it, for all I care.

I'm OK with it going - but as I said before I'd like to see mce_callin printed
(so I can tell if just one cpu showed up, just the cpus from one socket, or
some other significant number).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
