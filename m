Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaESOtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:49:11 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.6]:55605 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaESOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:49:08 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2014 10:49:08 EDT
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-2.tower-28.messagelabs.com!1400510535!3433855!16
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Mon, 19 May 2014 09:42:22 -0500
Subject: Re: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to
 debugfs
Thread-Topic: [PATCH 2/7] staging: unisys: move uislib/platform proc entry
 to debugfs
Thread-Index: Ac9zcIsvz1Nk4N0PQxqs4yoyN+JGig==
Message-ID: <C97001BC43954D438ACB059713BA5CDFA47DDAD93D@USEA-EXCH7.na.uis.unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
 <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
 <20140518164918.GA10285@kroah.com>
In-Reply-To: <20140518164918.GA10285@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4JEnKQq004250

On Sun, 2014-05-18 at 09:49 -0700, Greg KH wrote:
> There's no need to keep this dentry around, you can just remove all the
> debugfs files in your directory recursively when you exit.  That will
> save you code and logic overall.

Ah, thanks! I wasn't aware that I could do that. That's an easy fix. :)


> I'll leave this for now, you can clean that up in a future patch.

Thanks! I'll do that. :)


> Also, why are these entries moving to debugfs at all?  Why are they
> needed?  Who will use them?  Are tools relying on them to be there?

The tuning entries are sometimes used to help adjust the behavior of our
IO service partitions for better performance. I'm not sure about the
platform entry, but I'll find out if anyone still uses it. If not, I'll
send another patch to remove it entirely.

> thanks,
> 
> greg k-h

-- 
Ben Romer | Software Engineer |
Virtual Systems Development 

Unisys Corporation |  2476
Swedesford Rd |  Malvern, PA 19355
|  610-648-7140



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
