Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaANWZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:25:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:53698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaANWZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:25:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="466701385"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "standby24x7@gmail.com" <standby24x7@gmail.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH] [trivial] ixgbe: Fix format string in ixgbe_fcoe.c
Thread-Topic: [PATCH] [trivial] ixgbe: Fix format string in ixgbe_fcoe.c
Thread-Index: AQHPEXd/Y3sxCv3yckKtAOM3SDwLog==
Date: Tue, 14 Jan 2014 22:25:14 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312CAA3@ORSMSX101.amr.corp.intel.com>
References: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0EMPZQS003971

On Wed, 2014-01-15 at 01:14 +0900, Masanari Iida wrote:
> cppcheck detected following warning in ixgbe_fcoe.c
> (warning) %d in format string (no. 1) requires 'int' but the
> argument type is 'unsigned int'.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-) 

Thanks Masanari, I have added it to our internal queue for testing.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
