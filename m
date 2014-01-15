Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaAOXee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:34:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:38934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaAOXeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="467346537"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "davem@davemloft.net" <davem@davemloft.net>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "standby24x7@gmail.com" <standby24x7@gmail.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH] [trivial] ixgbe: Fix format string in ixgbe_fcoe.c
Thread-Topic: [PATCH] [trivial] ixgbe: Fix format string in ixgbe_fcoe.c
Thread-Index: AQHPEkpVK0lpcnu8BUmM5ftyTm6pnQ==
Date: Wed, 15 Jan 2014 23:34:29 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312DB97@ORSMSX101.amr.corp.intel.com>
References: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
 <20140115.145547.1868806980328924895.davem@davemloft.net>
In-Reply-To: <20140115.145547.1868806980328924895.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0FNYbXG013588

On Wed, 2014-01-15 at 14:55 -0800, David Miller wrote:
> From: Masanari Iida <standby24x7@gmail.com>
> Date: Wed, 15 Jan 2014 01:14:42 +0900
> 
> > cppcheck detected following warning in ixgbe_fcoe.c
> > (warning) %d in format string (no. 1) requires 'int' but the
> > argument type is 'unsigned int'.
> > 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Intel folks, please be sure to pick this up.

Yup, already in our queue.

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
