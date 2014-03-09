Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaCIPxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 11:53:54 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59317 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaCIPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 11:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140309065059.GA10398@kroah.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
	<20140309065059.GA10398@kroah.com>
Date: Sun, 9 Mar 2014 17:53:51 +0200
Message-ID: <CABdoFFco0zSDZ_21FbErKjPyX_R-kz+7WY-VuYa2q=KgRbX6vg@mail.gmail.com>
Subject: Re: [PATCH 00/18] Resend of usbip-utils migration patches and various
 other fixes
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, Andy Grover <andy.grover@gmail.com>,
        ihadzic@research.bell-labs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was notified that one of the patches in the series (staging: usbip:
claim ports used by shared devices) breaks the build.
I take full responsability for this as I haven't compiled the kernel
with allyesconfig and I am sorry.

This can be fixed by moving struct dev_state, usb_hub_claim_port() and
usb_hub_release_port() declarations from include/linux/usb.h to
usbip/stub.h, and leaving the declarations in usb/core/usb.h
untouched.

Should the fix come as a separate patch or v2 of the broken one?

Thanks,
Valentina
