Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaIHQaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:30:52 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.104]:43190 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbaIHQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:30:51 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-9.tower-201.messagelabs.com!1410193849!16082115!1
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
Date: Mon, 8 Sep 2014 11:30:48 -0500
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Topic: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Index: Ac/Lgj9NJGjpkFwcR8irDKF/rYcEXw==
Message-ID: <C97001BC43954D438ACB059713BA5CDFC97127E0E3@USEA-EXCH7.na.uis.unisys.com>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
 <20140908162714.GA5497@fool>
In-Reply-To: <20140908162714.GA5497@fool>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s88GUuPT032269

On Mon, 2014-09-08 at 21:57 +0530, Sudip Mukherjee wrote:
> Hi Ben,
> thanks. the same file is having two more similar warnings. if you want i can
> resend a patch fixing all the three warnings , or i can send two separate
> patches. 
> I personally will prefer two separate patches , as that will be
> easier for you to test and review.
> 
> thanks
> sudip

That would be perfect, thanks. :)

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
