Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaG2UW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:22:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:32590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaG2UWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:22:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,759,1400050800"; 
   d="scan'208";a="550889349"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] i40e: use correct structure type name in sizeof
Thread-Topic: [PATCH 3/9] i40e: use correct structure type name in sizeof
Thread-Index: AQHPq2rMNGMDyYUKkUSGGsmVNhLdiw==
Date: Tue, 29 Jul 2014 20:22:20 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B73369BF3@ORSMSX104.amr.corp.intel.com>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
 <1406647011-8543-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1406647011-8543-4-git-send-email-Julia.Lawall@lip6.fr>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6TKMTTs027416

On Tue, 2014-07-29 at 17:16 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Correct typo in the name of the type given to sizeof.  Because it is the
> size of a pointer that is wanted, the typo has no impact on compilation or
> execution.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
> semantic patch used can be found in message 0 of this patch series.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Julia, I have added your patch to our (Jeff's) queue.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
