Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3ILOWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:22:39 -0400
Received: from mx12.netapp.com ([216.240.18.77]:27962 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3ILOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:22:38 -0400
X-IronPort-AV: E=Sophos;i="4.90,891,1371106800"; 
   d="scan'208";a="88984463"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sunrpc: Add missing kuids conversion for printing
Thread-Topic: [PATCH] sunrpc: Add missing kuids conversion for printing
Thread-Index: AQHOr7laOTklg86CRUuqmWIp+UhYpZnCnPKA
Date: Thu, 12 Sep 2013 14:22:36 +0000
Message-ID: <1378995755.3117.10.camel@leira.trondhjem.org>
References: <1378991379-9106-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1378991379-9106-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9216D69AE9D8A54EA354059174804351@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CEMknn013000

On Thu, 2013-09-12 at 15:09 +0200, Geert Uytterhoeven wrote:
> m68k/allmodconfig:
> 
> net/sunrpc/auth_generic.c: In function â€˜generic_key_timeoutâ€™:
> net/sunrpc/auth_generic.c:241: warning: format â€˜%dâ€™ expects type â€˜intâ€™, but
> argument 2 has type â€˜kuid_tâ€™
> 
> commit cdba321e291f0fbf5abda4d88340292b858e3d4d ("sunrpc: Convert kuids and
> kgids to uids and gids for printing") forgot to convert one instance.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Thanks! Applied...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
