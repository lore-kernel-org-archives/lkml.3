Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3JWHxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3JWHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:36 -0400
Date: Wed, 23 Oct 2013 09:53:14 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>
Cc: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "keir@xen.org" <keir@xen.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131023075314.GT3626@debian70-amd64.local.net-space.pl>
References: <20131022165140.GL3626@debian70-amd64.local.net-space.pl>
 <CE8C01A3.244A%richard.l.maliszewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE8C01A3.244A%richard.l.maliszewski@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 05:21:15PM +0000, Maliszewski, Richard L wrote:
> The latter.  The code I was looking at definitely has the linuxefi
> directive.  FWIW, if you install FC18/19 on an EFI system, the grub2
> config file uses the linuxefi and companion initrd directives for launch.
>
> --Richard
>
> On 10/22/13 9:51 AM, "Daniel Kiper" <daniel.kiper@oracle.com> wrote:
>
> >On Tue, Oct 22, 2013 at 04:36:04PM +0000, Maliszewski, Richard L wrote:
> >> I may be off-base, but when I was wading through the grub2 code earlier
> >> this year, it looked to me like it was going to refuse to launch
> >>anything
> >> via MB1 or MB2 if the current state was a secure boot launch.
> >
> >Are you talking about upstream GRUB2 or GRUB2 with tons of distros
> >patches including linuxefi one. If later one it could be the case.

I realized that in SB case GRUB2 with linuefi patches does not have
a lot features (correct me if I am wrong). So you are able to just
load Linux or something which supports Linux Boot protocol. It is
not so flexible as it was designed. I think that it should be changed
and support for others systems/hypervisors should be added without
breaking SB support of course. GRUB2 upstream solution is preferred.

Daniel
