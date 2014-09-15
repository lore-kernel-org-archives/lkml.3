Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaIONzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:55:36 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaIONzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:55:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures using
Date: Mon, 15 Sep 2014 15:55:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, eparis@redhat.com,
        paulmck@linux.vnet.ibm.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        zhenglong.cai@cs2c.com.cn, khilman@linaro.org, ak@linux.intel.com,
        mcgrof@suse.com, fabf@skynet.be,
        "dhowells@redhat.com" <dhowells@redhat.com>, pefoley2@pefoley.com,
        mgorman@suse.de, biederm@xmission.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.de>
References: <540494D6.40701@gmail.com> <5406FFBD.8010207@gmail.com> <54155B14.9060809@gmail.com>
In-Reply-To: <54155B14.9060809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201409151555.03997.arnd@arndb.de>
X-Provags-ID: V02:K0:JZPpyAGN76J37BIG6PXM4/tLbPs1HAmUiMWNIcIoEA9
 zBAbvvR28JafTxjDiLNA68YXhS3WzMBA5HHAtGe1nL4wAGeLQv
 31ej2y81grADRqUwMDUjuF9rWc4ypP3dmKEeUXuqW3rtjud36j
 WF9rcOAVKNQBwfIY3pgMEj7JfRbRvcuF7Kg28LX+QZE63ZPB0W
 BlTmNWhBoDALsl0KZd0yUoES5zWJQRxJS/YKvmJkTzIqADlV3N
 SJILEVzFbN/prZuKKrPTE4wLfxUtGXL6i1zqrr8zmqN25QUcUW
 a1DPtkt5/AC2+ctvmsajzE/1ti+6vj4d6SG4tCb9Yil7NOcywx
 34JCJ+Kwf7tRE4xoCaHgLJnNYiVQGnvVOjhlCmw6c
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2014, Chen Gang wrote:
> Hello Maintainers:
> 
> Is this patch worthy enough to be applied?
> 
> Welcome any ideas, suggestions or completions.

I find it hard to judge whether it's worth it or not. You gave one example
for a driver that needs this, but what would be your estimate on how
many other drivers have the same problem, either producing a #warning
or misbehaving if neither symbol is set?

Having all architectures consistently report the endianess would be nice,
but we have to weigh the advantages (currently broken code, potential
simplifications) against the regression risk.

	Arnd
