Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3BDLDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:03:12 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61170 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3BDLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:03:09 -0500
Date: Mon, 4 Feb 2013 12:03:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
Message-ID: <20130204110304.GD24173@gmail.com>
References: <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
 <20130129074746.GA594@gmail.com>
 <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
 <20130129084914.GB5350@gmail.com>
 <CAE9FiQXe2QHacwyJx+5MQWmoGYW1Swnr5M-MSircgfA4_9e19Q@mail.gmail.com>
 <20130131113230.GD4587@gmail.com>
 <FE3E8B88161FFE48B03E3B93408433EC67110405@G9W0754.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE3E8B88161FFE48B03E3B93408433EC67110405@G9W0754.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang, Song-Bo (Stoney) <song-bo.wang@hp.com> wrote:

>  * Ingo Molnar <mingo.kernel.org@gmail.com> wrote:
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > Please check attached.
> > 
> > Almost good.
> > 
> > This:
> > 
> >   > When some HP sytems boot without x2apic_phys, there will be
> > 
> > Should mention the approximate models of the systems affected - is it
> > just a specific line of systems, or a wider range of systems affected?
> > 
> > This will inform users and will help maintainers like me to prioritize
> > the merging and backporting of patches.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> Due to some HW limitation, HP ProLiant DL980 G7 Server has the 
> BIT ACPI_FADT_APIC_PHYSICAL set in BIOS.
> 
> This model of systems already shipped. It is great if some 
> backporting could be done.

Ok, please re-send the last version of the patch with the model 
information included in the changelog and also include a Cc: 
<stable@kernel.org> tag before your signoff line.

Thanks,

	Ingo
