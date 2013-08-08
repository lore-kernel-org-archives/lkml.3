Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab3HHN64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:58:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60648 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab3HHN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:58:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH part2 0/4] acpi: Trivial fix and improving for memory hotplug.
Date: Thu, 08 Aug 2013 16:09:10 +0200
Message-ID: <1851799.n4moZnvj4u@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 08, 2013 01:03:55 PM Tang Chen wrote:
> This patch-set does some trivial fix and improving in ACPI code
> for memory hotplug.
> 
> Patch 1,3,4 have been acked.
> 
> Tang Chen (4):
>   acpi: Print Hot-Pluggable Field in SRAT.
>   earlycpio.c: Fix the confusing comment of find_cpio_data().
>   acpi: Remove "continue" in macro INVALID_TABLE().
>   acpi: Introduce acpi_verify_initrd() to check if a table is invalid.
> 
>  arch/x86/mm/srat.c |   11 ++++--
>  drivers/acpi/osl.c |   84 +++++++++++++++++++++++++++++++++++++++------------
>  lib/earlycpio.c    |   27 ++++++++--------
>  3 files changed, 85 insertions(+), 37 deletions(-)

It looks like this part doesn't depend on the other parts, is that correct?

Rafael

