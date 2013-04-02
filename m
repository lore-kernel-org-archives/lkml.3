Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab3DBFcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:32:07 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58874 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760415Ab3DBFbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAC=cRTPyC0rrDeRaMop3GF17qa3i2mfQ3XyHgNaEmiKNOE1Auw@mail.gmail.com>
References: <2282655.IicBMMa6jN@vostro.rjw.lan>
	<1378320.ernsY1JWPv@vostro.rjw.lan>
	<CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com>
	<3943547.m5K1tfygWn@vostro.rjw.lan>
	<CAC=cRTPyC0rrDeRaMop3GF17qa3i2mfQ3XyHgNaEmiKNOE1Auw@mail.gmail.com>
Date: Tue, 2 Apr 2013 13:31:47 +0800
Message-ID: <CAC=cRTOsPdYjLMrTGYi9PF27i6rqG9nm=RizfX+vkOz-bn1S8w@mail.gmail.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>, Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 1:28 PM, huang ying <huang.ying.caritas@gmail.com> wrote:
> On Tue, Apr 2, 2013 at 4:51 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> On Monday, April 01, 2013 11:34:46 AM Bjorn Helgaas wrote:
>> > [+cc Zheng, who added this with 71a83bd727]
>> >
>> > On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > >
>> > > The runtime PM of PCIe ports turns out to be quite fragile, as in
>> > > some cases things work while in some other cases they don't and we
>> > > don't seem to have a good way to determine whether or not they are
>> > > going to work in advance.
>> >
>> > Do you have any references to problems encountered when enabling
>> > runtime PM for PCIe ports?  That information will be useful to anybody
>> > who wants to take another crack at getting this working.
>>
>> Well, bug 53811 is one example and problems recently reported by
>> Martin are another.  Do you want me to dig deeper?
>
> For bug 53811, I have a debug patch posted in bugzilla to disable
> runtime PM for PCIe port with hotplug capability.  It appears that
> patch resolved the issue for the reporter.  Do think that patch can
> solve the hotplug issue.

For Martin's hotplug issue, it appears that a similar patch I sent to
him resolve his hotplug issue too.  For Martin's "XHCI dead port"
issue, that is, PME issue.  I just sent him another debug patch to
try.  Sorry for late!

Best Regards,
Huang Ying
