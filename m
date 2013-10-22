Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3JVO7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:59:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56020 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3JVO7j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 22 Oct 2013 10:59:39 -0400
Message-Id: <5266AEF702000078000FCB9C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 22 Oct 2013 15:59:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ian Campbell" <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "Peter Jones" <pjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <20131022145140.GA18679@phenom.dumpdata.com>
In-Reply-To: <20131022145140.GA18679@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.10.13 at 16:51, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> And I still haven't found the module that can launch any PE/COFF
> image from GRUB2. Maybe that is a myth.

I can't exclude that this is a custom a patch as the linuxefi support.

Jan

