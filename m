Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933Ab3FUH1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:27:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56507 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3FUH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:27:35 -0400
Date: Fri, 21 Jun 2013 09:27:25 +0200
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
Message-ID: <20130621072725.GB22006@pd.tnic>
References: <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
 <20130619210706.GP28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
 <51C37251.4000008@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA8993C@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA8993C@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:11:27PM +0000, Luck, Tony wrote:
> > - Two, the Generic Error Data Entry (aka UEFI Section Descriptor) has a 
> > flag which indicates 'Error Threshold Exceeded'. From the UEFI spec, it 
> > looks like we could consider this as an indication to offline the page; 
> > though I am not sure if/how this relates to the threshold value above.
> 
> This one sounds to make sense ... the flag description sounds exactly what
> we want - I won't feel embarrassed explaining to people why Linux takes
> action when it sees a record like this.

Yep, and firmware can set that flag when it wants to, so decision when
to offline a page is left to the platform.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
