Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3GVRDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:03:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25076 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab3GVRDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:03:30 -0400
Date: Mon, 22 Jul 2013 19:03:07 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Brandon Philips <brandon@ifup.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
Message-ID: <20130722170307.GB14451@debian70-amd64.local.net-space.pl>
References: <20130719020603.GA22932@kroah.com>
 <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
 <20130719151243.GA15488@kroah.com>
 <20130719183235.GA12267@debian70-amd64.local.net-space.pl>
 <20130719191449.GA1882@kroah.com>
 <51E9A85D.2060206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E9A85D.2060206@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 01:58:05PM -0700, H. Peter Anvin wrote:
> On 07/19/2013 12:14 PM, Greg KH wrote:
> >>
> >>> The errors that the kexec tools seem to run into is finding the memory
> >>> to place the new kernel into, is that just an issue that PV guests
> >>> aren't given enough kernel memory in which to replicate themselves from
> >>> dom0?
> >>
> >> There are a lot of differences between baremetal machines and PV guests.
> >> For example you are not able to do identity mapping per se in PV guests.
> >> Arguments to new kernel are passed in completely different way. etc.
> >
> > Ok, thanks for confirming that it is possible, but doesn't currently
> > work for pv guests.
> >
>
> Also, in any virtualized environment the hypervisor can do a better job
> for things like kdump, simply because it can provide two things that are
> otherwise hard to do:
>
> 1. a known-good system state;
> 2. a known-clean kdump image.
>
> As such, I do encourage the virtualization people to (also) develop
> hypervisor-*aware* solutions for these kinds of things.

In general I agree but if you could not change hypervisor
and/or dom0 (e.g. you are using cloud providers which are
stick to old versions of Xen) then you have no choice.

Daniel
