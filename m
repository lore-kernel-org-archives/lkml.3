Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3FTFfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:35:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3FTFfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:35:18 -0400
Date: Thu, 20 Jun 2013 07:35:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130620053510.GC32694@pd.tnic>
References: <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
 <20130619210706.GP28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
 <20130619214145.GS28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA885A5@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA885A5@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:08:53PM +0000, Luck, Tony wrote:
> > The above question about what to do *without* going to userspace and
> > back is maybe more interesting and we'd need a clean design there...
> > we'll see.
> 
> Yes - this case (where the BIOS did all the threshold math and made the decision)
> should be one where Linux kernel could just implement the action directly.
> Perhaps controlled by a knob to say whether we really trust the BIOS that much.
> 
> But we will also have cases where a smart user agent can correlate data
> from multiple sources to identify the real root cause (e.g. some temperature
> anomalies around the same time as some memory errors that occur at 10am
> on the third Tuesday each month -> cause is air conditioner maintenance guy
> that shuts down the a/c for 10 minutes to change the filter).

Surely we cannot put that in the kernel. For that we'd need userspace to
decide and only turn knobs in the kernel.

> I'll leave writing an agent that smart as an exercise for the concerned data
> center manager :-)

Me too, as long as it stays in userspace and it only turns
knobs/interfaces in the kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
