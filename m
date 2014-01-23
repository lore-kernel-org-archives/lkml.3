Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaAWHlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:41:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:64527 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaAWHl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:41:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,704,1384329600"; 
   d="scan'208";a="463330467"
From: "Brown, Len" <len.brown@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] suspend: make sync() on suspend-to-RAM optional
Thread-Topic: [PATCH 1/1] suspend: make sync() on suspend-to-RAM optional
Thread-Index: AQHPGAq3gRHtQBA3DE+j9xymb170hZqSb7OA//99ATA=
Date: Thu, 23 Jan 2014 07:41:12 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948452C570A@FMSMSX106.amr.corp.intel.com>
References: <ce1b9fc9cdcfd1fe8f9f3b8570421271dc15ae75.1390460951.git.len.brown@intel.com>
 <1390462163.10944.4.camel@rzhang1-mobl4>
In-Reply-To: <1390462163.10944.4.camel@rzhang1-mobl4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0N7fapo022097

> > +	depends on PM_SLEEP
>
> this is actually a suspend specific feature, and it should depends on
> SUSPEND instead?

yup, will update.

thanks,
-Len

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
