Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935819Ab3IELsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:48:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60349 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934435Ab3IELst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:48:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org,
        liwanp@linux.vnet.ibm.com, tj@kernel.org, akpm@linux-foundation.org,
        joe@perches.com, toshi.kani@hp.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] acpi: Fix and cleanup in acpi.
Date: Thu, 05 Sep 2013 13:59:41 +0200
Message-ID: <1718213.EiNcXEP20Z@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5227E4E4.9050705@cn.fujitsu.com>
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com> <17694789.JU3fWJ8s3q@vostro.rjw.lan> <5227E4E4.9050705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 05, 2013 09:56:52 AM Tang Chen wrote:
> On 09/05/2013 07:50 AM, Rafael J. Wysocki wrote:
> > On Tuesday, September 03, 2013 04:45:37 PM Tang Chen wrote:
> >> This patch-set fix the following problems:
> >>
> >> 1. Kill useless function save_add_info() which will block us from using
> >>     numa when MEMORY_HOTPLUG is not configured.
> >> 2. acpi_table_parse() didn't check if @id is NULL.
> >> 3. Fix incorrect comment in acpi_table_parse(), and return -ENOENT if a
> >>     table is not found.
> >>
> >> And also did some cleanup.
> >>
> >> change log v1 ->  v2:
> >> 1. Use pr_fmt() to simply the SRAT message.
> >>     Suggested by Joe Perches<joe@perches.com>
> >> 2. Improve the log in patch 4, and change the return value of the stub of
> >>     acpi_table_parse() in linux/acpi.h
> >>     Suggested by Toshi Kani<toshi.kani@hp.com>
> >> 3. Merge the two pr_{info|err} patches into one.
> >> 4. Remove on of the patch that has been merged by Rafael.
> >>
> >> Tang Chen (4):
> >>    acpi, numa, mem_hotplug: Kill save_add_info().
> >>    acpi cleanup: Use pr_{info|err}() instead of printk() in
> >>      arch/x86/mm/srat.c
> >>    acpi: Check if @id is NULL in acpi_table_parse()
> >>    acpi: Return -ENOENT in acpi_table_parse() and fix wrong comment.
> >
> > Thanks for the patches!
> >
> > Peter, any objections against [1-2/4]?  If not, I'll queue them up for 3.13.
> 
> Hi Rafael,
> 
> Thanks for the checking. As Ishimatu has sent some comments for patch 2, 
> I'd like
> to send a v3 patch-set soon. Please queue the coming v3 patches.

Sure, thanks.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
