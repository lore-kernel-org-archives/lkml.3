Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaFJJEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:04:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaFJJEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:04:44 -0400
Date: Tue, 10 Jun 2014 11:01:25 +0200
From: Borislav Petkov <bp@suse.de>
To: Ian Campbell <Ian.Campbell@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
 helper
Message-ID: <20140610090125.GB28607@pd.tnic>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
 <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
 <20140607090430.GA27457@nazgul.tnic>
 <20140609171525.GL22052@wotan.suse.de>
 <1402389339.29301.3.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402389339.29301.3.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 09:35:39AM +0100, Ian Campbell wrote:
> Actually what I meant was to *replace* kvmconfig with virtconfig and
> then add the Xen stuff to it, i.e. to have a single thing to maintain
> for all virt platforms, rather than end up with all 3 options.
> 
> I think the overhead of having some Xen stuff enabled in .config when
> running on KVM and vice versa is small.

Hmm, no. I'm running my kvm-enabled configs on baremetal too and I
wouldn't want any overhead at all. So kvmconfig and xenconfig should be
separate targets with separate config files please.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
