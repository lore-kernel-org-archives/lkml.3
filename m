Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbbAQAFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:05:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:57437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbbAQAFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:05:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,413,1418112000"; 
   d="scan'208";a="663208457"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>
Subject: RE: [PATCH v4 4/5] pstore: add pmsg
Thread-Topic: [PATCH v4 4/5] pstore: add pmsg
Thread-Index: AQHQL49oEs/5c81oGU6fcq+a+XAfAZzAc04AgAL/ZaA=
Date: Sat, 17 Jan 2015 00:05:18 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329AC184@ORSMSX114.amr.corp.intel.com>
References: <1421194580-20230-1-git-send-email-salyzyn@android.com>
 <CAGXu5jKz8Thhf8ZncVg-j-t1BCZTvQLkS1FN4yTtLkO1MY2CLA@mail.gmail.com>
In-Reply-To: <CAGXu5jKz8Thhf8ZncVg-j-t1BCZTvQLkS1FN4yTtLkO1MY2CLA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0H05j9H025895

> Cool, seems reasonable to me. Thanks for the respins!

I've applied it - but I have a nagging worry about it being user accessible.  We've limited
access to some pstore features on platforms that only support backend drivers that
write to limited lifetime flash storage - efivars & erst.  Should we do that for this too?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
