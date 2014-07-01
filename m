Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaGABXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:23:24 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:36922
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbaGABXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:23:22 -0400
From: Dudley Du <dudl@cypress.com>
To: Patrik Fimml <patrikf@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Thread-Topic: [PATCH v2 0/14] input: cyapa: re-architecture driver to
 support multi-trackpads in one driver
Thread-Index: AQHPkmJ9t+T52SM2e0uifNVuU/yAn5uJBvZQgAFS9ICAABblcA==
Date: Tue, 1 Jul 2014 01:23:07 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902ED4@S04-MBX01-01.s04.local>
References: <CAEn7tidaRxbLwQti8joDgq48K2YCAVE3uG-q6ZR=jEWAgm2tPg@mail.gmail.com>
 <77BC725C9062764F874D79F51E1F1A8F4C902B3B@S04-MBX01-01.s04.local>
 <20140630195935.GA18256@google.com>
In-Reply-To: <20140630195935.GA18256@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.155]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s611NTfC018420

Hi Patrik,

Thanks for your patient and detail instructions.
I will try to fix these issues and resubmit again.

Thanks,
Dudley

> -----Original Message-----
> From: Patrik Fimml [mailto:patrikf@chromium.org]
> Sent: Tuesday, July 01, 2014 4:00 AM
> To: Dudley Du
> Cc: Dmitry Torokhov; Rafael J. Wysocki; Alan Stern; Benson Leung; Lily Rui;
> Daniel Kurtz; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 0/14] input: cyapa: re-architecture driver to support
> multi-trackpads in one driver
>
> Hi Dudley,
>
> On Mon, Jun 30, 2014 at 05:43:06AM +0000, Dudley Du wrote:
> > Attached are the patches files, I sent it firstly.
>
> Thanks for the response, I was able to apply the patches now.
>
> The attached files lack headers and commit messages though, so I don't have
> fine-grained history in my git tree for convenient later review. The file
> names
> suggest to me that you might just have copy-and-pasted the patches from
> somewhere.
>
> It would be great if you could attach them again in the format produced by
> "git
> format-patch", with no further modifications done by hand. (If you feel the
> need to do modifications, you should modify the actual commits e.g. with "git
> rebase -i" before using format-patch.) Others can then simply import your
> changes - including commit messages - into their tree with "git am".
>
> Thanks,
> Patrik
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
