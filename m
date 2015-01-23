Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbbAWPTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:19:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48229 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbbAWPTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:19:41 -0500
X-IronPort-AV: E=Sophos;i="5.09,454,1418083200"; 
   d="scan'208";a="220017602"
Date: Fri, 23 Jan 2015 15:19:25 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <hpa@zytor.com>,
        <josh@joshtriplett.org>, <sam@ravnborg.org>,
        <stefano.stabellini@eu.citrix.com>, <bpoirier@suse.de>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <julien.grall@linaro.org>, <rientjes@google.com>,
        <yann.morin.1998@free.fr>
Subject: Re: [PATCH v3 0/2] x86/arm64: add xenconfig
In-Reply-To: <20150123003450.GV17887@wotan.suse.de>
Message-ID: <alpine.DEB.2.02.1501231517070.18131@kaball.uk.xensource.com>
References: <1421264027-10706-1-git-send-email-mcgrof@do-not-panic.com> <20150123003450.GV17887@wotan.suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Luis R. Rodriguez wrote:
> On Wed, Jan 14, 2015 at 11:33:45AM -0800, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This v3 addresses Stefano's feedback from the v2 series, namely
> > moving PCI stuff to x86 as its all x86 specific and also just
> > removing the CONFIG_TCG_XEN=m from the general config. To be
> > clear the changes from the v2 series are below.
> > 
> > Luis R. Rodriguez (2):
> >   x86, platform, xen, kconfig: clarify kvmconfig is for kvm
> >   x86, arm, platform, xen, kconfig: add xen defconfig helper
> > 
> >  arch/x86/configs/xen.config | 10 ++++++++++
> >  kernel/configs/xen.config   | 26 ++++++++++++++++++++++++++
> >  scripts/kconfig/Makefile    |  7 ++++++-
> >  3 files changed, 42 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/x86/configs/xen.config
> >  create mode 100644 kernel/configs/xen.config
> 
> Who could these changes go through?

I would be OK with taking it in the Xen tree, but I would feel more
comfortable doing that if you had an ack from Yann Morin (CC'ed).
