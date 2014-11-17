Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaKQSdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:33:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:57724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaKQSdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:33:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,404,1413270000"; 
   d="scan'208";a="609248588"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sebastian Schmidt" <yath@yath.de>
Subject: RE: linux-next: build warning after merge of the ia64 tree
Thread-Topic: linux-next: build warning after merge of the ia64 tree
Thread-Index: AQHQAjss7vVa8cZiKkuIZTfyupbHn5xlJLCA
Date: Mon, 17 Nov 2014 18:31:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293E7B7@ORSMSX114.amr.corp.intel.com>
References: <20141117184959.15d4dbb8@canb.auug.org.au>
In-Reply-To: <20141117184959.15d4dbb8@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In file included from kernel/printk/printk.c:41:0:
> include/linux/syslog.h:55:12: warning: 'check_syslog_permissions' defined but not used [-Wunused-function]
>  static int check_syslog_permissions(int type, bool from_file)

Bah - missed the "inline".  Fixed now.

Thanks

-Tony
