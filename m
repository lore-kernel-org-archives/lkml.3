Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaIHQDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:03:43 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.110]:30791 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbaIHQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:03:41 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 12:03:41 EDT
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-7.tower-201.messagelabs.com!1410191817!16199248!42
X-Originating-IP: [192.61.61.105]
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
Date: Mon, 8 Sep 2014 10:57:08 -0500
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Topic: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Thread-Index: Ac/LfYtlOfaFgiPsQg2hrGeqH97cnQ==
Message-ID: <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s88G3lgF032146

On Fri, 2014-09-05 at 14:52 +0530, Sudip Mukherjee wrote:
> fixed sparse warning : context imbalance in 'pause_device' 
> 			unexpected unlock
> this patch will generate warning from checkpatch for 
> lines over 80 character , but since those are user-visible strings
> so it was not modified.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> hi , can you please review the patch and see if the approach is correct.
> The functiion is still doing the same what it was doing , only the logic
> is changed. if the approach is ok, then i can send a patch to fix the
> other two similar warning in the file.

Hi Sudip,

I was able to successfully build and test your patch. The changes look
good to me too, so I think we should take this patch. :)

Thanks!
-- Ben

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
Tested-by: Benjamin Romer <benjamin.romer@unisys.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
