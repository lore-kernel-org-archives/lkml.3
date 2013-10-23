Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3JWHFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:05:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24674 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JWHFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:05:49 -0400
Date: Wed, 23 Oct 2013 09:05:28 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131023070528.GQ3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com>
 <52663D54.2020800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52663D54.2020800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:54:44AM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 21.10.2013 23:16, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> > Mail is big, I think I got your essential points but I didn't read it whole.
> > On 21.10.2013 14:57, Daniel Kiper wrote:
> >> Hi,
> >>
> >> During work on multiboot2 protocol support for Xen it was discovered
> >> that memory map passed via relevant tag could not represent wide range
> >> of memory types available on EFI platforms. Additionally, GRUB2
> >> implementation calls ExitBootServices() on them just before jumping
> >> into loaded image. In this situation loaded system could not clearly
> >> identify reserved memory regions, EFI runtime services regions and others.
> >>
> > Will a multiboot2 tag with whole EFI memory map solve your problem?
> I added such a tag in documentation and wrote a patch for it (attached).

Thanks. Could you send me a pointer to current multiboot2 protocol docs?

> Awaiting for someone to test it to commit

On first sight it looks quite nice. However, as I know Solaris guys
prepared similar solution. I am not sure it was discussed with GRUB2
guys. However, I think that it is worth coordinating both works and
do not break existing solution if it is possible.

I will try to get more details about Solaris implementation.

Daniel
