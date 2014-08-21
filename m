Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaHUOza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:55:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:27082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaHUOz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,909,1400050800"; 
   d="scan'208";a="471223165"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: "eliezer.tamir@linux.intel.com" <eliezer.tamir@linux.intel.com>
CC: "hykim@myri.com" <hykim@myri.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        "dmitry@broadcom.com" <dmitry@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 3.12 078/104] ixgbe: fix qv_lock_napi call in
 ixgbe_napi_disable_all
Thread-Topic: [PATCH 3.12 078/104] ixgbe: fix qv_lock_napi call in
 ixgbe_napi_disable_all
Thread-Index: AQHPvHCiuZg78ReBuEmhXwjOJ/YEZpvbSucAgABRcgA=
Date: Thu, 21 Aug 2014 14:55:26 +0000
Message-ID: <1408632926.20771.3.camel@jekeller-desk1.amr.corp.intel.com>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
	 <0977e9849d561464d21afb92b9f3746588a19c4f.1408535000.git.jslaby@suse.cz>
	 <53F5C40C.8040100@linux.intel.com>
In-Reply-To: <53F5C40C.8040100@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.173.156]
Content-Type: text/plain; charset="utf-8"
Content-ID: <315CB93711995A40BEFA734DB6C0C0F5@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7LEvY35006788

On Thu, 2014-08-21 at 13:03 +0300, Eliezer Tamir wrote:
> On 20/08/2014 14:43, Jiri Slaby wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> > 
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> No objection, I am however unable to test this myself at the moment.
> 
> I would suggest that someone takes a look at other drivers that support
> busypoll, to make sure that they don't have a similar issue.
> 
> -Eliezer

This was tested and resolved an issue found in the net-next kernel at
the time this was made, so I'd say it's had a fair amount of testing :)

Thanks,
Jake
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
