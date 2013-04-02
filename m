Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587Ab3DBFek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:34:40 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59843 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297Ab3DBFeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5iyziiGDKiy-416UQ2xr+2hvcHz6do+ueMmnPM5oy6Cw@mail.gmail.com>
References: <2282655.IicBMMa6jN@vostro.rjw.lan>
	<1378320.ernsY1JWPv@vostro.rjw.lan>
	<CAErSpo7kGBNEkLOftJ1J7ivaxZL-yVWyAwmoiQ1=NADpmJ67XA@mail.gmail.com>
	<3943547.m5K1tfygWn@vostro.rjw.lan>
	<CAErSpo5iyziiGDKiy-416UQ2xr+2hvcHz6do+ueMmnPM5oy6Cw@mail.gmail.com>
Date: Tue, 2 Apr 2013 13:34:35 +0800
Message-ID: <CAC=cRTNfUkgYzC-+tOw8hyP8k3qRd6jRU67NA7PwXpHNL+2c2A@mail.gmail.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
From: huang ying <huang.ying.caritas@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
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

Hi, Bjorn,

On Tue, Apr 2, 2013 at 4:53 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Apr 1, 2013 at 2:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Monday, April 01, 2013 11:34:46 AM Bjorn Helgaas wrote:
>>> [+cc Zheng, who added this with 71a83bd727]
>>>
>>> On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> >
>>> > The runtime PM of PCIe ports turns out to be quite fragile, as in
>>> > some cases things work while in some other cases they don't and we
>>> > don't seem to have a good way to determine whether or not they are
>>> > going to work in advance.
>>>
>>> Do you have any references to problems encountered when enabling
>>> runtime PM for PCIe ports?  That information will be useful to anybody
>>> who wants to take another crack at getting this working.
>>
>> Well, bug 53811 is one example and problems recently reported by
>> Martin are another.  Do you want me to dig deeper?
>
> OK, I got this one:
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=53811
>
> Martin has reported a lot of problems lately, and I don't know which
> are related to runtime PM for PCIe ports.  I was hoping for a couple
> URLs to put in the changelog so that when somebody gets the itch to
> make this work, they have some useful info to start from.  If you
> point me at a specific message, I'll dig up an archive URL for it.
>
> Otherwise, I'm afraid we'll just oscillate between "enable PM, find
> bug, disable PM, enable PM, find same bug, disable PM, etc..."

Sorry for late!  I am trying to fix a way to fix 53811 and Martin's
bug without disable PM for port totally.

Best Regards,
Huang Ying
