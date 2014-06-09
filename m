Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbaFIRP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:15:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaFIRP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:15:28 -0400
Date: Mon, 9 Jun 2014 19:15:25 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Borislav Petkov <bp@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
	helper
Message-ID: <20140609171525.GL22052@wotan.suse.de>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com> <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com> <20140607090430.GA27457@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140607090430.GA27457@nazgul.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 11:04:30AM +0200, Borislav Petkov wrote:
> On Fri, Jun 06, 2014 at 04:11:09PM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This lets you use:
> > 
> >    make virtconfig
> > 
> > to merge you current kernel configuration with options to
> > enable both kvm and xen (dom0 and guest) requirements.
> 
> What would be the use case for that?

This was based on a recommendation on xen-devel after review of
the xen RFC, the use case would be to enable usage of both in
one go. I'll drop this one.

  Luis
