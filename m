Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaFJIfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:35:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43169 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaFJIfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:35:42 -0400
X-IronPort-AV: E=Sophos;i="4.98,1007,1392163200"; 
   d="scan'208";a="141842881"
Message-ID: <1402389339.29301.3.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
 helper
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: Borislav Petkov <bp@suse.de>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, <levinsasha928@gmail.com>,
        <mtosatti@redhat.com>, <fengguang.wu@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>
Date: Tue, 10 Jun 2014 09:35:39 +0100
In-Reply-To: <20140609171525.GL22052@wotan.suse.de>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
	 <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
	 <20140607090430.GA27457@nazgul.tnic> <20140609171525.GL22052@wotan.suse.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 19:15 +0200, Luis R. Rodriguez wrote:
> On Sat, Jun 07, 2014 at 11:04:30AM +0200, Borislav Petkov wrote:
> > On Fri, Jun 06, 2014 at 04:11:09PM -0700, Luis R. Rodriguez wrote:
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > 
> > > This lets you use:
> > > 
> > >    make virtconfig
> > > 
> > > to merge you current kernel configuration with options to
> > > enable both kvm and xen (dom0 and guest) requirements.
> > 
> > What would be the use case for that?
> 
> This was based on a recommendation on xen-devel after review of
> the xen RFC,

Actually what I meant was to *replace* kvmconfig with virtconfig and
then add the Xen stuff to it, i.e. to have a single thing to maintain
for all virt platforms, rather than end up with all 3 options.

I think the overhead of having some Xen stuff enabled in .config when
running on KVM and vice versa is small.

Ian.

