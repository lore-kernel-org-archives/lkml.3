Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3I3DPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 23:15:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47416 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3I3DPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 23:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130930030655.GB21361@srcf.ucam.org>
References: <20130925001344.GA13554@redhat.com>
	<5245E7B1.2000408@zytor.com>
	<20130930025733.GA21361@srcf.ucam.org>
	<5248E8C2.2000108@zytor.com>
	<20130930030655.GB21361@srcf.ucam.org>
Date: Mon, 30 Sep 2013 13:15:02 +1000
Message-ID: <CAPM=9txNWRKPzE=FNz63fi-7mwQq5DvNkVHik4gNodD9WBP9mw@mail.gmail.com>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
From: Dave Airlie <airlied@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 1:06 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Sep 29, 2013 at 07:58:10PM -0700, H. Peter Anvin wrote:
>> On 09/29/2013 07:57 PM, Matthew Garrett wrote:
>> > On Fri, Sep 27, 2013 at 03:16:49PM -0500, H. Peter Anvin wrote:
>> >>
>> >> It really is starting to feel like *ALL* Dell machines need reboot=pci?
>> >
>> > Now that ACPI is default, I'd be surprised if any of them do.
>> >
>>
>> Look at the stream of Dell machines we're still getting reboot bug
>> reports for...
>
> Likely indicates that our ACPI reboot handling still isn't bug
> compatible with Windows. We'd do better fixing that than adding more DMI
> entries.

are these only with VTd enabled? I have some Dells that won't reboot
with VTd turned on, I remember you though it was an acpi bug we
couldn't do much with.

Dave.
