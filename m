Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3HENS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:18:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56544 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3HENSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:18:23 -0400
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
Subject: Re: [PATCH v2 RESEND 07/18] x86, ACPI: Also initialize signature and length when parsing root table.
Date: Mon, 05 Aug 2013 15:28:40 +0200
Message-ID: <5315714.F7fnXQVuXS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51FF00EC.1030609@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com> <3299662.WAS8YLIUlv@vostro.rjw.lan> <51FF00EC.1030609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 05, 2013 09:33:32 AM Tang Chen wrote:
> Hi Rafael,
> 
> On 08/02/2013 09:03 PM, Rafael J. Wysocki wrote:
> > On Friday, August 02, 2013 05:14:26 PM Tang Chen wrote:
> >> Besides the phys addr of the acpi tables, it will be very convenient if
> >> we also have the signature of each table in acpi_gbl_root_table_list at
> >> early time. We can find SRAT easily by comparing the signature.
> >>
> >> This patch alse record signature and some other info in
> >> acpi_gbl_root_table_list at early time.
> >>
> >> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> >> Reviewed-by: Zhang Yanfei<zhangyanfei@cn.fujitsu.com>
> >
> > The subject is misleading, as the change is in ACPICA and therefore affects not
> > only x86.
> 
> OK, will change it.
> 
> >
> > Also I think the same comments as for the other ACPICA patch is this series
> > applies: You shouldn't modify acpi_tbl_parse_root_table() in ways that would
> > require the other OSes using ACPICA to be modified.
> >
> 
> Thank you for the reminding. Please refer to the attachment.
> How do you think of the idea from Zheng ?

It's doable and, quite frankly, if the ACPICA maintainers are happy, I'm fine
with that too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
