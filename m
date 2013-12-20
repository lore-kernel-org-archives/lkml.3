Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3LTJjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:39:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48644 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3LTJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:38:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384300800"; 
   d="scan'208";a="84254223"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: David Miller <davem@davemloft.net>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH v3 8/8] drivers: net: Mark function
 xenvif_count_frag_slots() as static in netback.c
Thread-Topic: [PATCH v3 8/8] drivers: net: Mark function
 xenvif_count_frag_slots() as static in netback.c
Thread-Index: AQHO/JhyuX/GrQKbJkuwgWm/POSQUppcIOOAgACzPBA=
Date: Fri, 20 Dec 2013 09:38:55 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD01BE177@AMSPEX01CL01.citrite.net>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
 <20131219.185249.732943424956542038.davem@davemloft.net>
In-Reply-To: <20131219.185249.732943424956542038.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBK9daSI011624

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of David Miller
> Sent: 19 December 2013 23:53
> To: rashika.kheria@gmail.com
> Cc: Ian Campbell; Wei Liu; xen-devel@lists.xenproject.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> josh@joshtriplett.org
> Subject: Re: [PATCH v3 8/8] drivers: net: Mark function
> xenvif_count_frag_slots() as static in netback.c
> 
> From: Rashika Kheria <rashika.kheria@gmail.com>
> Date: Thu, 19 Dec 2013 14:26:47 +0530
> 
> > This patch marks the function xenvif_count_frag_slots() in netback.c as
> > static because they are not used outside this file.
> >
> > Thus, it also removes the following warning in xen-netback/netback.c:
> > drivers/net/xen-netback/netback.c:218:14: warning: no previous
> prototype for Ê½xenvif_count_frag_slotsÊ¼ [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> This patch doesn't apply cleanly to net-next, please respin.
> 

It won't apply to net-next. I removed that function in c/s ca2f09f2b2c6c25047cfc545d057c4edfcfe561c.

  Paul
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
