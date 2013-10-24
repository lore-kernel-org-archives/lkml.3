Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3JXGyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:54:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34568 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3JXGyC (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 24 Oct 2013 02:54:02 -0400
Message-Id: <5268D21502000078000A577A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 24 Oct 2013 07:53:57 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <phcoder@gmail.com>, <grub-devel@gnu.org>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, <daniel.kiper@oracle.com>,
        <konrad.wilk@oracle.com>, <mjg59@srcf.ucam.org>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <1382455358.18283.31.camel@hastur.hellion.org.uk>
 <20131022162632.GB19189@phenom.dumpdata.com>
 <1382517150.22417.21.camel@hastur.hellion.org.uk>
 <526803E902000078000A56D3@nat28.tlf.novell.com> <52680103.50601@gmail.com>
In-Reply-To: <52680103.50601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Vladimir 'φ-coder/phcoder' Serbinenko<phcoder@gmail.com> 10/23/13 7:02 PM >>>
>> GrUB - which iiuc stays in memory
>> after transferring control - could export its file system support to its
>> descendants).
>
>Xen shouldn't need to load any file after multiboot2 entry point. The
>needed files would already be in memory with pointers to them passed.

I should have said "to its chainloaded descendants".

>If you insist on being able to load directly from EFI, then IMO the best
>way is to have a PE executable with one of sections containing Xen and
>code which would load remaining files to memory and call common entry point.

I think you've been told before - this is what has been working already for quite
some time.

Jan

