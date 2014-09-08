Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaIHUkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:40:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49871 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753416AbaIHUkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:40:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <lenb@kernel.org>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v4 04/16] ACPI: Rename processor_core.c as apic_id.c
Date: Mon, 08 Sep 2014 23:00:14 +0200
Message-ID: <1537817.rgZoClELVE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540DA653.2000901@linaro.org>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1957879.bE3ICM6HKO@vostro.rjw.lan> <540DA653.2000901@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 08, 2014 08:51:31 PM Hanjun Guo wrote:
> Hi Gerry, Rafael,
> 
> On 2014年09月08日 06:37, Rafael J. Wysocki wrote:
> > On Thursday, August 28, 2014 10:22:29 AM Jiang Liu wrote:
> >> Now all code in processor_core.c is APIC ID related, so rename it as
> >> apic_id.c. Later IOAPIC ID related code will be added into apic_id.c.
> > Actually, I'm not sure about this one.
> >
> > Renames like this make it difficult to backport things in general
> > and kind of break "git blame", so do we have to do that?
> >
> > What's wrong with leaving the name as is and adding a comment
> > about the contents being related to IOAPIC ID?
> 
> It will be thankful for not renaming the file into apic_id.c, because apic id is x86 specific,
> and platform like ARM will also add some code to get cpu hardware id via GICC structure
> in MADT table in that file, apic id is not a generic name for both x86 and ARM, I prefer to
> keep it as it is :)

Well, that's a good argument too.

Rafael

