Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaFJJNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:13:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59859 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaFJJNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:13:52 -0400
X-IronPort-AV: E=Sophos;i="4.98,1008,1392163200"; 
   d="scan'208";a="141853932"
Message-ID: <1402391628.29980.15.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
 helper
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Borislav Petkov <bp@suse.de>
CC: "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, <levinsasha928@gmail.com>,
        <mtosatti@redhat.com>, <fengguang.wu@intel.com>,
        "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>
Date: Tue, 10 Jun 2014 10:13:48 +0100
In-Reply-To: <20140610090125.GB28607@pd.tnic>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
	 <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
	 <20140607090430.GA27457@nazgul.tnic> <20140609171525.GL22052@wotan.suse.de>
	 <1402389339.29301.3.camel@kazak.uk.xensource.com>
	 <20140610090125.GB28607@pd.tnic>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 11:01 +0200, Borislav Petkov wrote:
> On Tue, Jun 10, 2014 at 09:35:39AM +0100, Ian Campbell wrote:
> > Actually what I meant was to *replace* kvmconfig with virtconfig and
> > then add the Xen stuff to it, i.e. to have a single thing to maintain
> > for all virt platforms, rather than end up with all 3 options.
> > 
> > I think the overhead of having some Xen stuff enabled in .config when
> > running on KVM and vice versa is small.
> 
> Hmm, no. I'm running my kvm-enabled configs on baremetal too and I
> wouldn't want any overhead at all. So kvmconfig and xenconfig should be
> separate targets with separate config files please.

NB the overhead I meant was a few kbs of .text and modules, not runtime
overhead.

Ian.

