Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3AQQag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:30:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:24576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab3AQQad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:30:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="273324236"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "lliubbo@gmail.com" <lliubbo@gmail.com>,
        "jaegeuk.hanse@gmail.com" <jaegeuk.hanse@gmail.com>,
        "glommer@parallels.com" <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Index: AQHN8jfezP7hxPPawkaXDMerNaAcgJhJm6qAgABUxAD//3o84IAAiNyAgAISxwCAAPydgIAAFvqAgABpLACAAA9IAIAAJ0zw
Date: Thu, 17 Jan 2013 16:30:31 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C986D98@ORSMSX108.amr.corp.intel.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
 <50F440F5.3030006@zytor.com>
 <20130114143456.3962f3bd.akpm@linux-foundation.org>
 <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
 <20130114144601.1c40dc7e.akpm@linux-foundation.org>
 <50F647E8.509@jp.fujitsu.com>
 <20130116132953.6159b673.akpm@linux-foundation.org>
 <50F72F17.9030805@zytor.com> <50F78750.8070403@jp.fujitsu.com>
 <50F79422.6090405@zytor.com>
In-Reply-To: <50F79422.6090405@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0HGUbRR030540

> 2. If the user *does* care which nodes are movable, then the user needs 
> to be able to specify that *in a way that makes sense to the user*. 
> This may mean involving the DMI information as well as SRAT in order to 
> get "silk screen" type information out.

One reason they might care would be which I/O devices are connected
to each node.  DMI might be a good way to get an invariant name for the
node, but they might also want to specify in terms of what they actually
want. E.g. "eth0 and eth4 are a redundant bonded pair of NICs - don't
mark both these nodes as removable".  Though this is almost certainly not
a job for kernel options, but for some user configuration tool that would
spit out the DMI names.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
