Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3FDOqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:46:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37547 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3FDOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:46:36 -0400
Date: Tue, 4 Jun 2013 10:44:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 12/19]  xen: Enable PV ticketlocks on HVM Xen
Message-ID: <20130604144419.GE7110@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192503.5966.70501.sendpatchset@codeblue>
 <20130603155759.GE4224@phenom.dumpdata.com>
 <51AD9465.6000508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD9465.6000508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 12:46:53PM +0530, Raghavendra K T wrote:
> On 06/03/2013 09:27 PM, Konrad Rzeszutek Wilk wrote:
> >On Sun, Jun 02, 2013 at 12:55:03AM +0530, Raghavendra K T wrote:
> >>xen: Enable PV ticketlocks on HVM Xen
> >
> >There is more to it. You should also revert 70dd4998cb85f0ecd6ac892cc7232abefa432efb
> >
> 
> Yes, true. Do you expect the revert to be folded into this patch itself?
> 

I can do them. I would drop this patch and just mention in
the cover letter that Konrad would have to revert two git commits
to re-enable it on PVHVM.

