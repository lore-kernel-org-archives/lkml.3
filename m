Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3JVOKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:10:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51807 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3JVOKh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 22 Oct 2013 10:10:37 -0400
Message-Id: <5266A37802000078000FCB2D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 22 Oct 2013 15:10:32 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <ian.campbell@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <grub-devel@gnu.org>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, "Daniel Kiper" <daniel.kiper@oracle.com>,
        "Peter Jones" <pjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
In-Reply-To: <1382449985.18283.12.camel@hastur.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.10.13 at 15:53, Ian Campbell <ian.campbell@citrix.com> wrote:
> On Tue, 2013-10-22 at 09:42 -0400, Konrad Rzeszutek Wilk wrote:
> 
>> Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is 
> defined
>> in the linux/Documentation/x86/boot.txt and hpa is pretty strict
>> about making it backwards compatible. It also seems to support Xen!
>> 
>> (Interestingly enough we do have this structure in the code: see
>> setup_header in arch/x86/bzimage.c)
> 
> There will be another usage in tools/libxc/...bzimage too
> 
> FWIW I think we only use this stuff for the magic number/version and the
> payload_offset/length fields, which we do in order to extract the
> payload (ELF file) for booting dom0 and domU. It's not AFAIK used for
> booting Xen itself or lets say, that's not why I added it ;-)).

Indeed, we only use this to handle bzImage type kernels.

Jan

