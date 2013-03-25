Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3CYKUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:20:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:14273 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3CYKUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:20:19 -0400
Message-ID: <515024D2.6000008@huawei.com>
Date: Mon, 25 Mar 2013 18:20:02 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: report: IA64 boot failed when set "mem=xxG" in sparse memory
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IA64 platform, I change the config, set "Memory model (sparse Memory)",
do not set "Sparse Memory virtual memmap", others is based on SLES11's
default config(/boot/config-2.6.32.12-0.7-default).

After finish making a new kernel(v3.8), I add "mem=xxG" to the command line,
then reboot the system.

Boot failed and there is no print on the screen!

If both set "Memory model (sparse Memory)" and "Sparse Memory virtual memmap",
then add "mem=xxG" to the command line, reboot is OK.

I don't know whether it is a problem only in my system.

Thanks,
Xishi Qiu

