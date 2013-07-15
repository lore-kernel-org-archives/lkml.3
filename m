Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3GOVId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:08:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:54472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab3GOVIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,671,1367996400"; 
   d="scan'208";a="370685772"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>, Roland Dreier <roland@kernel.org>,
        "Hal Rosenstock" <hal.rosenstock@gmail.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RDMA/cma: silence GCC warning
Thread-Topic: [PATCH] RDMA/cma: silence GCC warning
Thread-Index: AQHOgUsIWMHwxd3x2kS4IP/5yaflNJlmO93Q
Date: Mon, 15 Jul 2013 21:08:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805A65C0@ORSMSX110.amr.corp.intel.com>
References: <1373886239.2591.26.camel@x61.thuisdomein>
In-Reply-To: <1373886239.2591.26.camel@x61.thuisdomein>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6FL8fLS012119

> 1) Perhaps a better way to silence GCC is to drop "port" entirely, and
> assign to "id_priv->id.port_num" directly. Would that be acceptable?

Yes, this would work.

- Sean
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
