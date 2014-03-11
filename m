Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaCKAP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:15:29 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:65441 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbaCKAP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:15:27 -0400
Message-ID: <1394496924.16134.40.camel@x220>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 11 Mar 2014 01:15:24 +0100
In-Reply-To: <CAErSpo6Q0w0OAenw7Uh0bjiZucpxatkUuWzREHmEvsNKJYf-qw@mail.gmail.com>
References: <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
	 <1394185698.5608.5.camel@x41>
	 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
	 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
	 <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
	 <1394289877.31006.2.camel@x41> <20140310182431.GA11424@google.com>
	 <1394495121.1975.6.camel@x41>
	 <CAErSpo6Q0w0OAenw7Uh0bjiZucpxatkUuWzREHmEvsNKJYf-qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2014 00:15:25.0798 (UTC) FILETIME=[00451060:01CF3CBF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 18:07 -0600, Bjorn Helgaas wrote:
> On Mon, Mar 10, 2014 at 5:45 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > A bit of doubt is caused by two new boot time messages:
> >     pnp 00:00: unknown resource type 10 in _CRS
> >     pnp 00:00: can't evaluate _CRS: 1
> >
> > But I haven't yet tried v3.14-rc6 without your patch, so these might be
> > unrelated. They're unclear to me, anyway.
> 
> Hmm, this is definitely concerning.  Resource type 10 is
> ACPI_RESOURCE_TYPE_FIXED_MEMORY32, which we do handle (unless it's
> length 0).  And your previous dmesg logs (at
> https://bugzilla.kernel.org/show_bug.cgi?id=71611) don't show anything
> like that.
> 
> Can you attach an acpidump and the dmesg log with my patch to the bugzilla?

It's getting rather late over here. So I'll try (quite) a few hours
later. But acpidump doesn't ring any bells right now. Any hints?

Thanks,


Paul Bolle

