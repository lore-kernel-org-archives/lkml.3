Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaAPCwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:52:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:9780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaAPCv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:51:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="467427421"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Topic: [PATCH 1/2 v3] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Index: AQHPEmXq4WU0ESFXDEOm9NkGu5QT7g==
Date: Thu, 16 Jan 2014 02:51:55 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312DF41@ORSMSX101.amr.corp.intel.com>
References: <1389795148-341-1-git-send-email-ethan.kernel@gmail.com>
 <309B89C4C689E141A5FF6A0C5FB2118B7312DA20@ORSMSX101.amr.corp.intel.com>
 <CABawtvNEDjTJAjJ9TeEvZd7+2kD=H6zA23T-aQo3uVm5SUEhCQ@mail.gmail.com>
 <309B89C4C689E141A5FF6A0C5FB2118B7312DE7D@ORSMSX101.amr.corp.intel.com>
 <CABawtvNSpDU+pjdJOpCB8kyQqA7B9N4g0S_yPgQaZnB3h0+nFg@mail.gmail.com>
In-Reply-To: <CABawtvNSpDU+pjdJOpCB8kyQqA7B9N4g0S_yPgQaZnB3h0+nFg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G2qYY1014803

On Thu, 2014-01-16 at 09:58 +0800, Ethan Zhao wrote:
> Aaron,
> 
> Is this your net-next repo ? if so, I rebuild the patch with this repo
> right now .
> git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-next.git
> 
> Thanks,
> Ethan
> 
Only sort of.  Jeff uses it to push patches up, but I don't have an
account there so am simply sending them up the old fashioned way, via
email, hence it is probably not getting updated while Jeff is out.

As long as your patch can apply cleanly to Dave Miller's net-next tree I
should be able to pull it into our internal ones.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
