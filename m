Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3LMVJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:09:02 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29085 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LMVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:09:00 -0500
Date: Fri, 13 Dec 2013 14:08:54 -0700
From: jerry.hoemann@hp.com
To: hpa@linux.intel.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Jingbai Ma <jingbai.ma@hp.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v10] x86, apic, kexec, Documentation: Add
 disable_cpu_apic kernel parameter
Message-ID: <20131213210854.GA31895@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <529EE392.6060400@jp.fujitsu.com>
 <20131210144910.GC13909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210144910.GC13909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:49:10AM -0500, Vivek Goyal wrote:
> On Wed, Dec 04, 2013 at 05:10:58PM +0900, HATAYAMA Daisuke wrote:
> > This patch set is to allow kdump 2nd kernel to wake up multiple CPUs,
> > a continueing work from:
> > 
> >   [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
> >   https://lkml.org/lkml/2013/10/16/300.
> > 
> > At v4, basic design has changed. Now users need to figure out initial
> > APIC ID of BSP in the 1st kernel and configures kernel parameter for
> > the 2nd kernel manually using disable_cpu_apicid kernel parameter,
> > which is newly introduced by this patch set. This design is more
> > flexible than the previous version in that we no longer have to rely
> > on ACPI/MP table to get initial APIC ID of BSP.
> > 
> > Sorry, this patch set have not include in-source documentation
> > requested by Borislav Petkov yet, but I'll post it later separately,
> > which would be better to focus on documentation reviewing.
> 
> Hi hpa,
> 
> Can you please consider this patch for inclusion.
> 
> Thanks
> Vivek


  hpa,

  Yes,  please consider including this patch as it addresses
  some scaling issues we are having with kdump on our new
  systems.

  Thanks

  Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

