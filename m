Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3JVPXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:23:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9150 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3JVPXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:23:49 -0400
X-IronPort-AV: E=Sophos;i="4.93,548,1378857600"; 
   d="scan'208";a="66072780"
Message-ID: <1382455424.18283.32.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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
Date: Tue, 22 Oct 2013 16:23:44 +0100
In-Reply-To: <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	,<1382449985.18283.12.camel@hastur.hellion.org.uk>
	 <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 14:18 +0000, Woodhouse, David wrote:
> > I wonder why Linux can't make the EFI calls to fetch them itself?
> 
> It can. It does. It prefers to. This is what the "EFI boot stub" is all about.

Good, this is what I thought, glad to see I'm not talking out my behind
for once!

> Seriously, forget bootloaders (especially grub2) and make it a COFF/PE
> executable.  Then everything should just work, including Secure Boot
> etc.
> 
> And bootloaders can still load that, of course.

Ack!

Ian.

