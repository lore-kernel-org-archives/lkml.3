Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3KHA4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:56:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:36668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab3KHA4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="318511043"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Daniel Borkmann <dborkman@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org.#.3.12" <stable@vger.kernel.org.#.3.12>
Subject: Re: [PATCH] net: don't forget to free sk_filter
Thread-Topic: [PATCH] net: don't forget to free sk_filter
Thread-Index: AQHO2w35HCJlCwMu/UG0+qQ8VmHOjpoZGi8AgAACggCAAe3tAA==
Date: Fri, 8 Nov 2013 00:56:09 +0000
Message-ID: <1383872168.9330.23.camel@jekeller-desk1.amr.corp.intel.com>
References: <1383753106-26978-1-git-send-email-avagin@openvz.org>
	 <527A9638.4020404@redhat.com>
	 <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.173.156]
Content-Type: text/plain; charset="utf-8"
Content-ID: <606FFAAEF723A84EA3CA2B3D92D8AEB5@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA80uM5i003126

On Wed, 2013-11-06 at 11:28 -0800, Eric Dumazet wrote:
> On Wed, 2013-11-06 at 20:19 +0100, Daniel Borkmann wrote:
> 
> > When you send v2 with Alexei's feedback, please also be more specific
> > in your subject like "net: x86: bpf: don't forget to free sk_filter"
> > or the like. Also it's enough to say 'This memory leak was introduced
> > by commit d45ed4a4e3 ("net: fix unsafe set_memory_rw from softirq")'
> > instead of copying the whole log. Anyways, for v2 with feedback included
> > then:
> 
> Actually, the new way [1] of doing this would be to use the 'Fixes:' tag
> as in :
> 
> Fixes: <12 digits SHA1> ("net: fix unsafe set_memory_rw from softirq")
> 
> [1] As discussed at last Kernel Summit
> 
> Example in 
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6920a1bd037374a632d585de127b6f945199dcb8
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Has there been any mention of a forthcoming patch
to ./Documentation/SubmittingPatches which documents this?

Thanks,
Jake
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
