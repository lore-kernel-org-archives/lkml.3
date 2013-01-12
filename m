Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3ALIyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 03:54:20 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:57167 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3ALIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 03:54:19 -0500
Message-ID: <50F124B9.30000@free-electrons.com>
Date: Sat, 12 Jan 2013 09:54:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/2] Add GPIO driver for Allwinner SoCs
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com> <CAOesGMiTZvLJ6cXwMFsFc6pBGoLUEkV+WMrDOqqCcs_TEnTtUw@mail.gmail.com> <CACRpkdZQAim4_3E6RG=d4pJi80B6W-xzW7n=Od86VJNcPO4FVw@mail.gmail.com>
In-Reply-To: <CACRpkdZQAim4_3E6RG=d4pJi80B6W-xzW7n=Od86VJNcPO4FVw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 12:13, Linus Walleij wrote:
> On Sat, Jan 5, 2013 at 4:35 PM, Olof Johansson <olof@lixom.net> wrote:
> 
>> I haven't looked closely at the patch yet, but this is a case where it
>> makes sense to merge the gpio/pinctrl patch through Linus/Grant's
>> tree, and merge the dtsi update through arm-soc -- while you need
>> both, nothing is broken by having just one or the other, so taking the
>> separate merge paths are fine.
>>
>> Linus, Grant, sound ok to you?
> 
> Sure. But I have requested a few changes to the patch set...

And we need to merge the pinctrl patches first also.

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
