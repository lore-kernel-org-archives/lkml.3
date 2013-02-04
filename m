Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3BDGwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:52:03 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43495 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3BDGwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:52:01 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 01:52:01 EST
From: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>
CC: "mingo.kernel.org@gmail.com" <mingo.kernel.org@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: RE: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Topic: [PATCH] x86/apic: check FADT settings after enable x2apic
Thread-Index: AQHN8sLbtrSsPj2mD0qoH/EbzuNDVZheOwHggAAo+YCAADY0gIAAhbwAgADkawCAAAizQIAACHkAgADa2YCAAnduAIAFsq6A
Date: Mon, 4 Feb 2013 06:41:32 +0000
Message-ID: <FE3E8B88161FFE48B03E3B93408433EC67110405@G9W0754.americas.hpqcorp.net>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
 <20130128101135.GD7168@gmail.com>
 <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
 <20130129074746.GA594@gmail.com>
 <FE3E8B88161FFE48B03E3B93408433EC671027BC@G9W0754.americas.hpqcorp.net>
 <20130129084914.GB5350@gmail.com>
 <CAE9FiQXe2QHacwyJx+5MQWmoGYW1Swnr5M-MSircgfA4_9e19Q@mail.gmail.com>
 <20130131113230.GD4587@gmail.com>
In-Reply-To: <20130131113230.GD4587@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Ingo Molnar <mingo.kernel.org@gmail.com> wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Please check attached.
> 
> Almost good.
> 
> This:
> 
>   > When some HP sytems boot without x2apic_phys, there will be
> 
> Should mention the approximate models of the systems affected - is it
> just a specific line of systems, or a wider range of systems affected?
> 
> This will inform users and will help maintainers like me to prioritize
> the merging and backporting of patches.
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

Due to some HW limitation, HP ProLiant DL980 G7 Server has the BIT ACPI_FADT_APIC_PHYSICAL set in BIOS.

This model of systems already shipped. It is great if some backporting could be done.

Thanks,

  Stoney
