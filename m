Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLRSUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:20:09 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44885 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLRSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:20:07 -0500
Message-ID: <54931AD3.1050305@gmail.com>
Date: Thu, 18 Dec 2014 21:20:03 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
References: <5492D938.1020907@gmail.com>	<20141218135705.GD4918@srcf.ucam.org>	<5492DEE7.8010407@gmail.com>	<20141218140930.GA6436@srcf.ucam.org>	<5492E32E.2030602@gmail.com>	<20141218142629.GA6924@srcf.ucam.org>	<5492E5F9.2000504@gmail.com>	<20141218143623.GA7335@srcf.ucam.org>	<5492E753.7090505@gmail.com>	<20141218144337.GA7613@srcf.ucam.org>	<20141218145054.GA7745@srcf.ucam.org> <CAJvTdKnejv9cKPW9sbnLswfBsWZCA1OU2os7iud9tKoq7CW+jw@mail.gmail.com>
In-Reply-To: <CAJvTdKnejv9cKPW9sbnLswfBsWZCA1OU2os7iud9tKoq7CW+jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

I completely agree that debugging and testing of a real solution would be a problem.
And adding "acpi_osi=" is not too hard as a boot option.

In some cases it can be built-in, if it is a box solution.

So the patch is no good.

18.12.2014 21:09, Len Brown пишет:
> NAK on addoing this acpi_osi= quirk to upstream Linux.
>
> The reason is that problem is being actively debugged.
> Quirks in upstream Linux are for when we give up.
>
> Sure, it is perfectly okay for individual users to invoke it.
> It is even fine for a distro to check in this workaround if they care
> about that box working *now*
> and they are not concerned about side effects.
>
> But the real fix is in development, and checking workarounds with
> possible other side-effects
> into up-stream Linux is just a distraction from getting it right for
> not just this machine,
> but other machines w/ the same issue.
>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
> ps. lots of people are mis-using acpi_osi= in debugging, please consult
> Documentation/kernel-parameters.txt for a detailed description of how
> this cmdline option works.  Note, in particular, that acpi_osi=XYZ by itself
> will _add_ XYZ to the list of recognized strings.  If that string is
> already built
> into Linux (eg. "Windows 2012"), then adding it again has no effect.
>
