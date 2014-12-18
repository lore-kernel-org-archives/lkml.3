Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaLROkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:40:25 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52397 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaLROkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:40:23 -0500
Message-ID: <5492E753.7090505@gmail.com>
Date: Thu, 18 Dec 2014 17:40:19 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
References: <5492C5A3.8090700@gmail.com> <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com> <5492D938.1020907@gmail.com> <20141218135705.GD4918@srcf.ucam.org> <5492DEE7.8010407@gmail.com> <20141218140930.GA6436@srcf.ucam.org> <5492E32E.2030602@gmail.com> <20141218142629.GA6924@srcf.ucam.org> <5492E5F9.2000504@gmail.com> <20141218143623.GA7335@srcf.ucam.org>
In-Reply-To: <20141218143623.GA7335@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But at least two devices work well with this quirk.
That must be some ASUS UEFI firmware fault, but still it is a workaround.
You can find some more information in those bugzilla reports.

https://bugzilla.kernel.org/show_bug.cgi?id=89401
https://bugzilla.kernel.org/show_bug.cgi?id=70241

18.12.2014 17:36, Matthew Garrett пишет:
> That's odd - it looks like the default behaviour in the absence of any
> OSI strings is to just default to an OSYS value that matches Windows
> 2012, so disabling the 2013 value should be equivalent. If it's not,
> it's definitely not safe to turn off all values - there are several
> devices that change behaviour as a result.
>
