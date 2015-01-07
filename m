Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbbAGHnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:43:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:62578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbbAGHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:43:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437408640"
Message-ID: <1420616586.6201.74.camel@intel.com>
Subject: Re: [LKP] [sb_edac] 50d1bb93672: EDAC sbridge: ECC is disabled.
 Aborting
From: Huang Ying <ying.huang@intel.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Wed, 07 Jan 2015 15:43:06 +0800
In-Reply-To: <20150105140606.GA25309@redhat.com>
References: <1418890406.26403.2.camel@intel.com>
	 <20141218090536.0d671dca@recife.lan> <1418966819.26403.33.camel@intel.com>
	 <20150105140606.GA25309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 09:06 -0500, Aristeu Rozanski wrote:
> Hi,
> On Fri, Dec 19, 2014 at 01:26:59PM +0800, Huang Ying wrote:
> > In fact, I am not complaining :-), just FYI. As I said, this may be a
> > expected behavior because this is a Haswell machine and the Haswell
> > support was added in this patch.
> > 
> > > From the above, what looks weird, from EDAC driver PoV, is:
> > > 	[   12.506298] EDAC sbridge: ECC is disabled. Aborting
> > 
> > This is what I want help from you to confirm whether it is abnormal.
> > 
> > > Does it used to work before? If so, was there any BIOS setting change?
> > > Does the memories used on this machine have ECC?
> > 
> > This is a high-end desktop, there is something as below in dmidecode
> > output.  Is there some other way to tell whether the memories have ECC?
> > 
> > Handle 0x0018, DMI type 16, 23 bytes
> > Physical Memory Array
> >         Location: System Board Or Motherboard
> >         Use: System Memory
> >         Error Correction Type: Multi-bit ECC
> >         Maximum Capacity: 128 GB
> >         Error Information Handle: Not Provided
> >         Number Of Devices: 4
> > 
> > Handle 0x001A, DMI type 17, 34 bytes
> > Memory Device
> >         Array Handle: 0x0018
> >         Error Information Handle: Not Provided
> >         Total Width: 72 bits
> >         Data Width: 72 bits
> >         Size: 8192 MB
> >         Form Factor: DIMM
> >         Set: None
> >         Locator: DIMM_A1
> >         Bank Locator: CPU 0
> >         Type: <OUT OF SPEC>
> >         Type Detail: Synchronous
> >         Speed: 1067 MHz
> >         Manufacturer: 0x11
> >         Serial Number: Unknown
> >         Asset Tag: Unknown
> >         Part Number: Unknown
> >         Rank: 1
> >         Configured Clock Speed: Unknown
> 
> unfortunately with this I can't say :(
> Do you mind checking on EFI or maybe looking at the memory modules' part
> number?

Do not find memory modules' part number in EFI menu.  Some information
about memory is:

2133MT/s Micron DRx8 8GB UDIMM

Best Regards,
Huang, Ying


