Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab3GSO6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:58:43 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34423 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3GSO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:58:41 -0400
MIME-Version: 1.0
X-Originating-IP: [67.180.19.67]
In-Reply-To: <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
References: <20130719020603.GA22932@kroah.com>
	<20130719131819.GC11233@debian70-amd64.local.net-space.pl>
Date: Fri, 19 Jul 2013 07:58:40 -0700
Message-ID: <CAK7GKxnB933DkO8qM6HxZCbDVNn4ze5Ere7ZWnXxBieYMg88dQ@mail.gmail.com>
Subject: Re: is kexec on Xen domU possible?
From: Brandon Philips <brandon@ifup.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:18 AM, Daniel Kiper <daniel.kiper@oracle.com> wrote:
>   - PV guests: there is no support for kexec at this time;
>     Once I wrote an implementatation for that type of guests
>     for one company but according to our agreement I could not
>     publish this code; However, I could use it as a base for
>     publicly available kexec implementation; Currently, I do
>     not have any plans to work on this due to some more important
>     stuff to do; However, question about kexec support for PV
>     guests is raised from time to time and maybe this issue
>     will be much more important than others once,

To do kexec on PV guests is there a dependency on support from the dom0?

e.g. if we recreated your patches and merged them into 3.12 and booted
on a XenServer from a few years ago would it work?

What I want to do is use kexec on existing public cloud providers,
that use Xen, like AWS or Rackspace.

Thanks,

Brandon
