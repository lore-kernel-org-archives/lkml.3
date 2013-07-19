Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001Ab3GSSUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:20:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39463 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3GSSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:20:03 -0400
Date: Fri, 19 Jul 2013 20:19:46 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
Message-ID: <20130719181946.GG11233@debian70-amd64.local.net-space.pl>
References: <20130719020603.GA22932@kroah.com>
 <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
 <CAK7GKxnB933DkO8qM6HxZCbDVNn4ze5Ere7ZWnXxBieYMg88dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7GKxnB933DkO8qM6HxZCbDVNn4ze5Ere7ZWnXxBieYMg88dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 07:58:40AM -0700, Brandon Philips wrote:
> On Fri, Jul 19, 2013 at 6:18 AM, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> >   - PV guests: there is no support for kexec at this time;
> >     Once I wrote an implementatation for that type of guests
> >     for one company but according to our agreement I could not
> >     publish this code; However, I could use it as a base for
> >     publicly available kexec implementation; Currently, I do
> >     not have any plans to work on this due to some more important
> >     stuff to do; However, question about kexec support for PV
> >     guests is raised from time to time and maybe this issue
> >     will be much more important than others once,
>
> To do kexec on PV guests is there a dependency on support from the dom0?

No.

> e.g. if we recreated your patches and merged them into 3.12 and booted
> on a XenServer from a few years ago would it work?

No.

> What I want to do is use kexec on existing public cloud providers,
> that use Xen, like AWS or Rackspace.

Look for HVM or PVonHVM guests support in this providers.
Sadly, there is no support for kexec on PV guests.

Daniel
