Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbbAFRkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:40:14 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40901 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbbAFRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:40:11 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:643f:af53:7746:ead2]
In-Reply-To: <CAL1qeaETERAm6aTwWycCat-RzQz8UmixWtc-uK4dFsu7wL8HAg@mail.gmail.com>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
	<1420540653-14816-3-git-send-email-tomeu.vizoso@collabora.com>
	<20150106130656.GF31830@ulmo.nvidia.com>
	<CAL1qeaETERAm6aTwWycCat-RzQz8UmixWtc-uK4dFsu7wL8HAg@mail.gmail.com>
Date: Tue, 6 Jan 2015 09:40:10 -0800
Message-ID: <CAOesGMj5EFr89SvskxjwjG8UdVPMJLO4-Up_5WLPUabqyqmXNw@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: tegra: Move out nyan-generic parts out from the
 nyan-big DT
From: Olof Johansson <olof@lixom.net>
To: Andrew Bresticker <abrestic@google.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Dylan Reid <dgreid@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:30 AM, Andrew Bresticker <abrestic@google.com> wrote:
> On Tue, Jan 6, 2015 at 5:06 AM, Thierry Reding <thierry.reding@gmail.com> wrote:

>>
>> Back when we merged the nyan-big DTS there was some discussion and it
>> was concluded that the devices are very similar, with the panel being
>> one notable exception. So I think that this belongs in the nyan-big
>> DTS and you need to add a similar property to the nyan-blaze DTS with
>> the compatible for the panel used in the design. And you might need
>> to add an entry for the panel in the panel-simple driver, too.
>
> That's correct.  There are also variants of big and blaze with 1080p
> panels, so those will definitely need their own panel nodes as well.
>
> Other than that,
>
> Acked-by: Andrew Bresticker <abrestic@chromium.org>

Shame on both of you for not pruning the patch when replying -- the
emails go too long for gmail to show them by default. :) :P

And yeah, this split looks reasonable to me (with the panel comment fixed)

Feel free to carry:

Acked-by: Olof Johansson <olof@lixom.net>
