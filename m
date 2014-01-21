Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaAUXE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:04:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:13699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaAUXEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:04:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="468666594"
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
Thread-Index: AQHPFv0xe1cN4Rs1G0C2iUxe2h/eYA==
Date: Tue, 21 Jan 2014 23:04:53 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B73142908@ORSMSX101.amr.corp.intel.com>
References: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0LN54fQ013421

On Wed, 2014-01-15 at 01:14 +0900, Masanari Iida wrote:
> cppcheck detected following warning in ixgbe_fcoe.c
> (warning) %d in format string (no. 1) requires 'int' but the
> argument type is 'unsigned int'.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Tested-By: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> index f58db45..0872617 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> @@ -585,7 +585,7 @@ static int ixgbe_fcoe_dma_pool_alloc(struct ixgbe_fcoe *fcoe,
>  	struct dma_pool *pool;
>  	char pool_name[32];
>  
> -	snprintf(pool_name, 32, "ixgbe_fcoe_ddp_%d", cpu);
> +	snprintf(pool_name, 32, "ixgbe_fcoe_ddp_%u", cpu);
>  
>  	pool = dma_pool_create(pool_name, dev, IXGBE_FCPTR_MAX,
>  			       IXGBE_FCPTR_ALIGN, PAGE_SIZE);


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
