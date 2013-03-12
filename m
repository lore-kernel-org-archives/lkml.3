Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3CLQQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:16:51 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54809 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab3CLQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130312160635.GA5379@pd.tnic>
References: <20130312160249.GA32182@codeblau.de>
	<20130312160635.GA5379@pd.tnic>
Date: Tue, 12 Mar 2013 12:16:48 -0400
Message-ID: <CADnq5_Mk3P4Jz7RypSrZrY48ceWxbtfdMZhoG4=7BOXCCqdFrw@mail.gmail.com>
Subject: Re: Who is responsible for radeon driver bugs?
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>, felix-linuxkernel@fefe.de,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:06 PM, Borislav Petkov <bp@alien8.de> wrote:
> Let's add some more people to CC.
>
> On Tue, Mar 12, 2013 at 05:02:49PM +0100, felix-linuxkernel@fefe.de wrote:
>> The radeon driver does not work on my laptop.
>> I sent a bug report here a week ago, but got no responses.
>> What is the right place to send bug reports for the radeon driver?
>>
>> The bug is that LVDS output does not work.  This is, according to lspci,
>> a 5000M series Madison Radeon.
>>
>> When I insmod the module, the screen stays in text mode and appears
>> locked up.
>>
>> If something is connected to the HDMI port, I get a framebuffer console
>> there.  LVDS stays in broken text mode though.
>>
>> When I start X, the HDMI screen turns dark and stays dark and the LVDS
>> screen also stays dark and I have to reboot.
>>
>> The driver loads the REDWOOD firmware OK.
>>
>> Who is responsible for this?  Where do I send my bug report?

Please file a bug report here:
https://bugs.freedesktop.org/
choose DRI as the product and DRM/Radeon as the component.  Make sure
to attach your dmesg output and Xorg log.
Also, is this a PowerXpress laptop?  I.e., laptop with both integrated
and discrete GPUs?

Alex
