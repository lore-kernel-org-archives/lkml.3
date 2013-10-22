Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JVPV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:21:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53819 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JVPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:21:58 -0400
X-IronPort-AV: E=Sophos;i="4.93,548,1378857600"; 
   d="scan'208";a="63403984"
Message-ID: <1382455307.18283.30.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "Peter Jones" <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Date: Tue, 22 Oct 2013 16:21:47 +0100
In-Reply-To: <20131022145724.GA18763@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	 <1382449985.18283.12.camel@hastur.hellion.org.uk>
	 <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
	 <20131022145724.GA18763@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 10:57 -0400, Konrad Rzeszutek Wilk wrote:
> That 'that' is a standard PE/COFF image?  Could you please point me
> to the code that does that in GRUB2?

As I said earlier in the thread, it's a patch which is being carried by
all the distros. It is not in upstream grub.

For instance here is Debian's version:
        http://anonscm.debian.org/loggerhead/pkg-grub/trunk/grub/download/head:/linuxefi.patch-20130129060348-21bhrqmbqj52c28w-1/linuxefi.patch
        
AIUI all the distros are carry basically the same patch.

Ian.

