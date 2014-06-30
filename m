Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaF3GzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:55:00 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:34946
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbaF3Gy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:54:59 -0400
From: Dudley Du <dudl@cypress.com>
To: Patrik Fimml <patrikf@google.com>
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
Thread-Index: AQHPkmJ9t+T52SM2e0uifNVuU/yAn5uJOpGA
Date: Mon, 30 Jun 2014 06:54:57 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902D71@S04-MBX01-01.s04.local>
References: <CAEn7tidaRxbLwQti8joDgq48K2YCAVE3uG-q6ZR=jEWAgm2tPg@mail.gmail.com>
In-Reply-To: <CAEn7tidaRxbLwQti8joDgq48K2YCAVE3uG-q6ZR=jEWAgm2tPg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6t6Zo009672

Hi All,

Sorry for the disturb again.
The 14 caypa V2 patches I re-sent through 14:41 to 14:45 at 2014/6/30 still have some of them corrupted by the mail server.
Please ignore them. I will try to fix them.

Thanks,
Dudley
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
