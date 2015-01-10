Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbbAJItB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:49:01 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33496 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbAJItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:49:00 -0500
MIME-Version: 1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Date: Sat, 10 Jan 2015 08:48:59 +0000
Message-ID: <CAJSP0QXx8PovhGT30A+S0hVDOX-Z4FODt2r7uXN0WyPU82C7YQ@mail.gmail.com>
Subject: Re: [PATCH 00/25] line6usb cleanup
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Chris Rorvick <chris@rorvick.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?Q?L=2E_Alberto_Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 5:35 AM, Chris Rorvick <chris@rorvick.com> wrote:
> The line6usb driver references the device's idProduct and, in some
> cases, the interface number in a number of places to determine device-
> specific configuration values and to call device-specific functionality.
> Rework code to leverage the device table matching more effectively.
> Consolidate configuration settings into the properties entries and use
> function pointers setup at initialization to remove much of the
> conditional logic.
>
> I have a TonePort UX2 that I've used for testing, meaning that some of
> this is really only compile-tested.

I no longer own a Pod HD300 so I cannot test these patches.  The code
looks fine.

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
