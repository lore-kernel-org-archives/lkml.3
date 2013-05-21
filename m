Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3EUSx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:53:58 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:38232 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab3EUSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:53:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Tue, 21 May 2013 11:49:33 -0700
Subject: RE: [RFC PATCH] net/wireless/mwifiex/pcie: Convert to dev_pm_ops
 from legacy pm ops
Thread-Topic: [RFC PATCH] net/wireless/mwifiex/pcie: Convert to dev_pm_ops
 from legacy pm ops
Thread-Index: AQHOVcuInHnHweBRfkqda9opXtALJ5kP+8YQ
Message-ID: <477F20668A386D41ADCC57781B1F70430E0ADCE838@SC-VEXCH1.marvell.com>
References: <1369103589.12093.4.camel@lorien>
In-Reply-To: <1369103589.12093.4.camel@lorien>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4LIs3Mm022590

Hi Shuah,

> Convert the driver to use dev_pm_ops for power management and remove Legacy PM
> handling. This change re-uses existing suspend and resume interfaces for
> dev_pm_ops.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> Suggested-by: rafael.j.wysocki@intel.com

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
> 
> Rafael,
> 
> This is the first driver patch to convert drivers to use dev_pm_ops for
> power management. Please review for the approach and make suggestions for
> improvement.
> 
> thanks,
> -- Shuah
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
