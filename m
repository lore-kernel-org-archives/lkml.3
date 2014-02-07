Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBGA1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 19:27:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:53501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaBGA1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 19:27:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,796,1384329600"; 
   d="scan'208";a="479347493"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [PATCH 3.13] mei: mei_hbm_dispatch() returns void
Thread-Topic: [PATCH 3.13] mei: mei_hbm_dispatch() returns void
Thread-Index: AQHPI4XiqAqFGikQBEyWSf+aDJV56Zqo4PyA
Date: Fri, 7 Feb 2014 00:26:59 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF69D63@HASMSX106.ger.corp.intel.com>
References: <20140204211036.967663852@linuxfoundation.org>
	 <20140204211038.509274283@linuxfoundation.org>
	 <1391722055.22187.7.camel@x220> <20140206213953.GA1524@kroah.com>
 <1391723609.1782.2.camel@x220>
In-Reply-To: <1391723609.1782.2.camel@x220>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s170RGPt008915

> 
> Building hbm.o for v3.13.2 triggers a GCC warning:
>     drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
>     drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in function
> returning void [enabled by default]
>        return 0;
>        ^
> 
> GCC is correct, obviously. So let's return void instead of zero here.

The patch was based on top of this one  http://www.spinics.net/lists/stable/msg31386.html , which was too big for stable,
So  your fix is correct here.
ACK.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
