Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3HGP1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:27:36 -0400
Received: from mx11.netapp.com ([216.240.18.76]:60945 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab3HGP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:27:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,833,1367996400"; 
   d="scan'208";a="39873076"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Nix <nix@esperi.org.uk>
CC: Jeff Layton <jlayton@redhat.com>,
        =?utf-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, NFS list <linux-nfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [3.10.4] NFS locking panic, plus persisting NFS shutdown panic
 from 3.9.*
Thread-Topic: [3.10.4] NFS locking panic, plus persisting NFS shutdown panic
 from 3.9.*
Thread-Index: AQHOk1eH4gcyFEImq0mWTcGQZbqon5mKU+4A
Date: Wed, 7 Aug 2013 15:27:31 +0000
Message-ID: <1375889252.6488.1.camel@leira.trondhjem.org>
References: <8761vlv4z9.fsf@spindle.srvr.nix>
	 <20130805084436.69ee4415@corrin.poochiereds.net>
	 <87siyotcri.fsf@spindle.srvr.nix>
	 <20130805110427.509db424@tlielax.poochiereds.net>
	 <20130805111106.73d6ab90@tlielax.poochiereds.net>
	 <87zjswrvaq.fsf@spindle.srvr.nix>
	 <1375719301.7337.14.camel@leira.trondhjem.org>
	 <20130805133739.21654ecb@tlielax.poochiereds.net>
	 <1375726682.7337.29.camel@leira.trondhjem.org>
	 <20130805143311.4ae59067@tlielax.poochiereds.net>
	 <1375755693.7337.42.camel@leira.trondhjem.org>
	 <87iozhst0s.fsf@spindle.srvr.nix>
In-Reply-To: <87iozhst0s.fsf@spindle.srvr.nix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <00E5B87D03B7E34784BD58358807C767@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r77FRkr2027352

On Wed, 2013-08-07 at 11:18 +0100, Nix wrote:
> On 6 Aug 2013, Trond Myklebust verbalised:
> > True. How about something like the following instead. Note the change to
> > the original patch...
> 
> Well, with those applied I could reboot without a panic for the first
> time since 3.8.x: looking good. I'll give it a reboot or two with a
> system that's not hot from booting though.
> 

Could you please also try applying only the 1/2 patch, to see if that
suffices to quell the shutdown panic?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
