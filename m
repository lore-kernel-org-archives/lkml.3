Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaIJN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:29:42 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:41499 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaIJN3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:29:40 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-16.tower-46.messagelabs.com!1410355771!37077634!26
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: "Kershner, David A" <David.Kershner@unisys.com>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Sep 2014 08:29:26 -0500
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Topic: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Index: Ac/M+z4OtcxHlFlZT0qafQjskyLwwg==
Message-ID: <C97001BC43954D438ACB059713BA5CDFC97127E0E7@USEA-EXCH7.na.uis.unisys.com>
References: <1410259269-27397-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1410259269-27397-1-git-send-email-sudipm.mukherjee@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8ADTkRx015389

On Tue, 2014-09-09 at 16:11 +0530, Sudip Mukherjee wrote:
> fixed sparse warning : context imbalance in 'resume_device'
>                         unexpected unlock
> this patch will generate warning from checkpatch for
> lines over 80 character , but since those are user-visible strings
> so it was not modified.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

I tested your changes, and this patch works fine. Thanks!

-- Ben

Acked-by: Benjamin Romer <benjamin.romer@unisys.com>
Tested-by: Benjamin Romer <benjamin.romer@unisys.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
