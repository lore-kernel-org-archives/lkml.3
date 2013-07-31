Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3GaAhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:37:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab3GaAhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:37:06 -0400
Message-ID: <1375230992.31262.87.camel@ul30vt.home>
Subject: Re: Linux Plumbers ACPI/PM, PCI Microconference
From: Alex Williamson <alex.williamson@redhat.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Shuah Khan <shuahkhan@gmail.com>,
        Myron Stowe <myron.stowe@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 18:36:32 -0600
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6174F0B5@sisaex01sj>
References: <CAL-B5D03ki8NHsM6EuESTH2K-Eh+XyFHNXPDYwgDq+oagDjtMQ@mail.gmail.com>
	 <CAKocOOOgEb5h1dZWP_2UqBKhSK9U-kxKUbvTdzHfds=RiDzNJg@mail.gmail.com>
	 <1476124.sWE2ygoo2D@vostro.rjw.lan>
	 <B8EFE96D1287C24090BAD9D858E15E6174F0B5@sisaex01sj>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 00:02 +0000, Shuah Khan wrote:
> On 07/30/2013 05:38 PM, Rafael J. Wysocki wrote:
> > On Wednesday, July 17, 2013 08:31:55 AM Shuah Khan wrote:
> >> Myron,
> >>
> >> On Tue, Jul 16, 2013 at 8:21 PM, Myron Stowe <myron.stowe@gmail.com> wrote:
> >>
> >>>
> >>> Shuah - You brought up the idea about "Converting drivers from Legacy
> >>> PM ops to dev_pm_ops"; would you like to present what you have
> >>> done/encountered so far?
> >>>
> >>
> >> Awesome. Yes, I would like to present what I have done so far and I do
> >> have a couple of things that could benefit from a face to face
> >> discussion which would help me make progress on the rest of the work
> >> that needs to get done.
> >
> > Care to sumbit a formal proposal through the LPC web page?
> >
> > Rafael
> >
> >
> 
> Rafael,
> 
> I did submit a formal talk proposal to LinuxCon/LPC and it was rejected. 
> Submission is closed now as far as I know.

Microconference topics should be submitted here:

http://www.linuxplumbersconf.org/2013/ocw/events/LPC2013/proposals/new

