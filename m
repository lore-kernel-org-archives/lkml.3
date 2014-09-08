Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaIHRSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:18:09 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:29212 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbaIHRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:18:07 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 13:18:07 EDT
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-8.tower-46.messagelabs.com!1410196255!31518721!1
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "Kershner, David A" <David.Kershner@unisys.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Sep 2014 12:10:55 -0500
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Topic: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Index: Ac/Lh9nU1xCoOFiyRBu4bQhP7OIqqw==
Message-ID: <C97001BC43954D438ACB059713BA5CDFC97127E0E5@USEA-EXCH7.na.uis.unisys.com>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
 <20140908170613.GB10454@kroah.com>
In-Reply-To: <20140908170613.GB10454@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s88HIEV7032630

On Mon, 2014-09-08 at 10:06 -0700, Greg Kroah-Hartman wrote:
> Traditionally, you would respond with a:
> 	Acked-by: Developer Name <email@address>
> so I can add it to the patch.
> 
> Care to do that here?
> 
> thanks,
> 
> greg k-h

Of course. :)

Acked-by: Benjamin Romer <benjamin.romer@unisys.com>

Should I do this instead of Tested-by and Signed-off-by, in the future?

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
