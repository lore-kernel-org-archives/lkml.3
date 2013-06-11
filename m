Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3FKVkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:40:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:43573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab3FKVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,847,1363158000"; 
   d="scan'208";a="351695216"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: RE: [PATCH v10 net-next 5/6] ixgbe: add support for ndo_ll_poll
Thread-Topic: [PATCH v10 net-next 5/6] ixgbe: add support for ndo_ll_poll
Thread-Index: AQHOZbZahmUIX4XMxUu5CAKDe8BPCJkvgB8AgAGMyJA=
Date: Tue, 11 Jun 2013 21:40:09 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58564F93E8@ORSMSX104.amr.corp.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
	 <20130610084020.6955.48255.stgit@ladj378.jer.intel.com>
 <1370876366.3252.6.camel@edumazet-glaptop>
In-Reply-To: <1370876366.3252.6.camel@edumazet-glaptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5BLeLNw016100

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Eric Dumazet
> Sent: Monday, June 10, 2013 7:59 AM
> To: Eliezer Tamir
> Cc: David Miller; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> Brandeburg, Jesse; Skidmore, Donald C; e1000-
> devel@lists.sourceforge.net; Willem de Bruijn; Ben Hutchings; Andi
> Kleen; HPA; Eilon Greenstien; Or Gerlitz; Amir Vadai; Eliezer Tamir
> Subject: Re: [PATCH v10 net-next 5/6] ixgbe: add support for ndo_ll_poll
> 
> On Mon, 2013-06-10 at 11:40 +0300, Eliezer Tamir wrote:
> > Add the ixgbe driver code implementing ndo_ll_poll.
> > Adds ndo_ll_poll method and locking between it and the napi poll.
> > When receiving a packet we use skb_mark_ll to record the napi it came
> from.
> > Add each napi to the napi_hash right after netif_napi_add().
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> > ---
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> 
> --

Acked-by: Jacob Keller <jacob.e.keller@intel.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
