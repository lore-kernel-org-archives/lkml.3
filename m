Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaE2LxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:53:22 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57463 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbaE2LxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140528145140.GN14863@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
	<CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
	<20140528020935.GB2820@darkstar.nay.redhat.com>
	<20140528145140.GN14863@redhat.com>
Date: Thu, 29 May 2014 12:53:19 +0100
Message-ID: <CAL01qpsb5_Gh31uqm7yB6HP2rKQkhFWWTu+U4JAR54XR5bfbZw@mail.gmail.com>
Subject: Re: [PATCH] export efi.flags to sysfs
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 15:51, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, May 28, 2014 at 10:09:35AM +0800, Dave Young wrote:
>
> [..]
>> > I've only vaguely been following along with the other thread, so please
>> > summarise everything again in your patch. Particularly, I need answers
>> > to the following questions,
>> >
>> >  - Are you trying to fix a kexec/kdump regression?
>>
>> Somehow it is a regression.
>
> Well, it is a *regression*. Previously kdump would work with
> SGI UV machines as it used "noefi". Now kexec by default thinks that
> efi is enabled and 1:1 mappings are in place and that does not work
> with SGI UV machines.

So, if someone boots an SGI UV machine with the "noefi" kernel command
line parameter, the kernel still creates
/sys/firmware/efi/runtime-map/ ? Why does kexec/kdump think a kernel
booted with "noefi" supports EFI?

Or are we talking about a different "noefi" parameter?
