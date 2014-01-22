Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaAVR4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:56:14 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50188 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaAVR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:56:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140122164100.GE15937@n2100.arm.linux.org.uk>
References: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
	<20140122164100.GE15937@n2100.arm.linux.org.uk>
Date: Wed, 22 Jan 2014 09:56:10 -0800
Message-ID: <CACUGKYP-AJ673573_6Hb49g44EEMS32SLSm1uKQztMg9yvx7NA@mail.gmail.com>
Subject: Re: Internal error: Oops: 17 [#1] ARM
From: John Tobias <john.tobias.ph@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran the kernel in our custom board and I've seen the error after
(sometimes 10 minutes after) the reboot and sometimes my board ran for
an hour or so before it happened.
I will try the 3.13-rc8 today and will see if the said bug still exist or not.

Regards,

john

On Wed, Jan 22, 2014 at 8:41 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 22, 2014 at 08:23:36AM -0800, John Tobias wrote:
>> Hello all,
>>
>> I am using 3.13-rc1 kernel on iMX6SL processor. My filesystem is in
>> eMMC running SDR50.
>> Is anyone here encountered these problem and if there's any existing
>> patch that I can get?.
>
> How reproducable is this?  I notice you're using 3.13-rc1 too, it could
> be the bug has already been fixed in a later kernel version.  -rc1
> kernels are really the "fresh after lots of new feature merging" kernels
> which should always be expected to be rather buggy.
>
> Linux kernel "release candidates" are not "we think this is going to be
> a final kernel, please test it" but -rc1 marks the end of the new
> feature merging and the beginning of the stablisation phase.
>
> --
> FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
> in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
> Estimate before purchase was "up to 13.2Mbit".
