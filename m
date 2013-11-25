Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3KYVNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:13:33 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:61946 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3KYVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:13:29 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1382327909-6140-1-git-send-email-bleung@chromium.org>
References: <1382327909-6140-1-git-send-email-bleung@chromium.org>
Date: Mon, 25 Nov 2013 13:13:26 -0800
Message-ID: <CAOesGMipE-fa=fOf+zx5-Ygjiobc-grjAw3GesVKx7Enhq6D8A@mail.gmail.com>
Subject: Re: [PATCH 0/6] Platform: x86: chromeos_laptop - Deferring and Haswell
From: Olof Johansson <olof@lixom.net>
To: Benson Leung <bleung@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        adurbin@chromium.org, Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>, enselic@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

On Sun, Oct 20, 2013 at 8:58 PM, Benson Leung <bleung@chromium.org> wrote:
> The following patch series refactors the dmi check system and
> returns -EPROBE_DEFER when an expected i2c adapter is not present
> at probe time.
>
> This will allow the touchpad, touchscreen, and light sensors on
> Pixel to load even if the i915 DDC and PANEL buses are instantiated
> after chromeos_laptop.
>
> The deferred probing patches were sent previously, and have been cleaned up
> slightly since.
>
> Also one patch to clean up the placement of __initdata for the dmi_table.
>
> Finally, add support for the Haswell generation Chromebook systems'
> peripherals over the new native i2c-designware-pci busses.
>
> The last three patches depend on this patch series :
> https://lkml.org/lkml/2013/10/20/136
>
> [PATCH 1/6] Platform: x86: chromeos_laptop - Restructure device associations
> [PATCH 2/6] Platform: x86: chromeos_laptop - Use deferred probing
> [PATCH 3/6] Platform: x86: chromeos_laptop - fix incorrect placement of __initdata tag
> [PATCH 4/6] Platform: x86: chromeos_laptop - Add names of Haswell ULT i2c busses
> [PATCH 5/6] Platform: x86: chromeos_laptop - Add HP Chromebook 14
> [PATCH 6/6] Platform: x86: chromeos_laptop - Add Acer C720

I've applied patch 1-3. Since the naming seems to still be up in the
air on the i2c side, I can't apply 4-6 yet.

I also switched the subject to platform/chrome: ... since that's what
I've picked to use on the other patches in the same directory.


-Olof
