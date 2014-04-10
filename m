Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbaDJO4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:56:52 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.100]:49324 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934661AbaDJO4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:56:50 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-8.tower-200.messagelabs.com!1397141805!15840620!10
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Apr 2014 09:56:42 -0500
Subject: Re: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Thread-Topic: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Thread-Index: Ac9UzRWfsDvnsBSsTvSv9QKZTSS2NQ==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F0C@USEA-EXCH7.na.uis.unisys.com>
References: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
 <20140409192552.GA11506@kroah.com>
In-Reply-To: <20140409192552.GA11506@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3AEuvto028332

On Wed, 2014-04-09 at 12:25 -0700, Greg Kroah-Hartman wrote:
> Patches need to do only one thing, so can you please split this up in to
> multiple patches, each one only doing one thing.

Sorry about that! I'll send another patch that fixes all of the
copyright statements at once then. :)

> You forgot to add a "Reported-by:" line here, and possibly a
> "Tested-by:" if someone tested it and reported that it solved the
> problem.  Proper attribution is very important.

Will do! Thanks for all the feedback. I'll rework my patch. :)

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
