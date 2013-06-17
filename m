Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3FQXkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:40:36 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56933 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FQXkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:40:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130617233827.GP32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
	<1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com>
	<20130617233827.GP32663@mtj.dyndns.org>
Date: Mon, 17 Jun 2013 16:40:34 -0700
X-Google-Sender-Auth: 83wO8tfxY7DDP1z3tzjVczrmhis
Message-ID: <CAE9FiQX9OtxdOLrsMB4zcYL7=B=MnKPNu5+fwfYhf_T2L24XOw@mail.gmail.com>
Subject: Re: [Part1 PATCH v5 07/22] x86, ACPI: Store override acpi tables phys
 addr in cpio files info array
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        Rik van Riel <riel@redhat.com>, jweiner@redhat.com,
        Prarit Bhargava <prarit@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 4:38 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jun 13, 2013 at 09:02:54PM +0800, Tang Chen wrote:
>> -static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
>> +struct file_pos {
>> +     phys_addr_t data;
>> +     phys_addr_t size;
>> +};
>
> Isn't file_pos too generic as name?  Would acpi_initrd_file_pos too
> long?  Maybe just struct acpi_initrd_file?

ok, will change to acpi_initrd_file.

Thanks

Yinghai
