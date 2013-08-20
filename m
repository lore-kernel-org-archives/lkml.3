Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3HTMr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:47:29 -0400
Received: from mail1.ams.com ([212.166.112.31]:43900 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3HTMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:47:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,920,1367964000"; 
   d="scan'208";a="4242116"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Date: Tue, 20 Aug 2013 14:39:48 +0200
Subject: RE: mfd: as3722: introducing ams AS3722 PMIC driver
Thread-Topic: mfd: as3722: introducing ams AS3722 PMIC driver
Thread-Index: Ac6doV4yH8D86MhxRwmHD23bzDK5KAAADuLQ
Message-ID: <EB31996D403C2C48A47628A08DCCFD2901857BCEF5@SUX2182.office.amsiag.com>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <20130820123237.GO23699@lee--X1>
In-Reply-To: <20130820123237.GO23699@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7KClYjk013850

On Tue, 20 Aug 2013, Lee Jones wrote:
> - http://kparal.wordpress.com/2011/08/18/git-tip-of-the-day-splitting-changes-into-several-patches/

> - http://nuclearsquid.com/writings/git-add/

Thank you very much for your hints and clarification on how to split up the patches. I think this point is clear to me now. We will need of course some time to split up the patches as requested.

In addition, how to deal with the sub-drivers of the mfd? Should those be included in the mfd driver patch as they are introduced or should they be treated as separate units?

Thanks again for your help, but as you might have already recognized, we are kernel newbies. At least in terms of getting code upstream.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
