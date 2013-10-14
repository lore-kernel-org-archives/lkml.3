Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab3JNX1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:27:37 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:42867 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3JNX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131014232239.GA29716@srcf.ucam.org>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
	<CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
	<1381421199.4248.2.camel@x230.lan>
	<CAMP44s04+_aP7KpVMTUjdNcRWMg6PC6HBaNhF_uhAHm=fhmTcw@mail.gmail.com>
	<20131013151729.GA4028@srcf.ucam.org>
	<CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
	<20131014155254.GB20187@srcf.ucam.org>
	<CAMP44s3O6z6-gVCqhCps7fKSKMbL9JSakZLfBUxqUYytrWFWKw@mail.gmail.com>
	<20131014232239.GA29716@srcf.ucam.org>
Date: Mon, 14 Oct 2013 18:27:33 -0500
Message-ID: <CAMP44s0vo+XAF_6Q9S2KGNyuEEPtn99qynuqcbE_=RYe3xM71g@mail.gmail.com>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "corentin.chary@gmail.com" <corentin.chary@gmail.com>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 6:22 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Oct 14, 2013 at 06:18:36PM -0500, Felipe Contreras wrote:
>> On Mon, Oct 14, 2013 at 10:52 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > It wouldn't be appropriate to alter the firmware behaviour by default,
>> > but yeah, that's the kind of thing that the thermal framework exists to
>> > do.
>>
>> Well, how do I do that? The driver is up and running, and I can
>> manually set different fan speeds, however nothing seems to happen
>> automatically when the temperature increases.
>
> The easiest is to just do it from userspace. I think Intel have some
> code for doing this, but I haven't looked at the thermal code for years.

That defeats the purpose of the whole thermal binding infrastructure.

>> > I don't think you can easily register multiple drivers for the same WMI
>> > device.
>>
>> I don't mean this one, I mean the standalone one. Actually, the first
>> one I sent doesn't require all this system memory stuff.
>
> Banging EC registers directly is the wrong thing to do. Going via WMI is
> correct.

I'm not going to bother arguing against your absolutist rhetoric. The
fact is one patch can be applied, the other can't. Besides, nobody
said anything about banging EC registers directly.

-- 
Felipe Contreras
