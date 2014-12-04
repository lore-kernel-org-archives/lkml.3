Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaLDKzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:55:15 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:44829 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaLDKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:55:13 -0500
MIME-Version: 1.0
Reply-To: rogelio.serrano@gmail.com
In-Reply-To: <CAB_-8bKBC9T-35U3=g5gL7qcg6DrfhPuk2154-yLkuwko7HZFw@mail.gmail.com>
References: <CANszf4jKHq-WY=+W=D3mFEnhL9=aZJ+-Mx7yp9kw=hYTi+gGFA@mail.gmail.com>
	<CA+rthh8q1+hh7wvZg8hXB4j-WyQm-ainU0X2Cb_mnGwLM9DW_Q@mail.gmail.com>
	<CAB_-8bLXD65f=eX-kudZC8LHBUk50qCK=w_B1wbXe=A4egU1RQ@mail.gmail.com>
	<CA+rthh_xhUytmh26pBUh7q9uocDv4VdbtXvz-tMJSJSeVT3FNw@mail.gmail.com>
	<CAB_-8bKBC9T-35U3=g5gL7qcg6DrfhPuk2154-yLkuwko7HZFw@mail.gmail.com>
Date: Thu, 4 Dec 2014 10:55:11 +0000
Message-ID: <CAB_-8bL-UmFBoEsk27bEqifyOnhg-xO9PkamfDibttbTCxXUWA@mail.gmail.com>
Subject: Fwd: mysterious udev segfault
From: "Rogelio M. Serrano Jr." <rogelios664@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Rogelio M. Serrano Jr. <rogelios664@gmail.com>
Date: Thu, Dec 4, 2014 at 10:53 AM
Subject: Re: mysterious udev segfault
To: Mathias Krause <minipli@googlemail.com>


On Thu, Dec 4, 2014 at 8:13 AM, Mathias Krause <minipli@googlemail.com> wrote:
>
<snipped...>
>
> Probably not. But I don't think the grsec patch changes anything
> related to firmware loading.
> Upstream added an option to disable firmware loading via udev
> (CONFIG_FW_LOADER_USER_HELPER_FALLBACK). Maybe that's related.
> Again, logs may help here.
>
>
> Regards,
> Mathias

both loadable kernel modules and loader user helper fallback are off

Dec  3 10:18:02 (none) klogd: [    1.789031] iwl4965: Intel(R)
Wireless WiFi 4965 driver for Linux, in-tree:
Dec  3 10:18:02 (none) klogd: [    1.790767] iwl4965: Copyright(c)
2003-2011 Intel Corporation
Dec  3 10:18:02 (none) klogd: [    1.792484] iwl4965 0000:03:00.0:
can't disable ASPM; OS doesn't have ASPM control
Dec  3 10:18:02 (none) klogd: [    1.794421] iwl4965 0000:03:00.0:
Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
Dec  3 10:18:02 (none) klogd: [    1.839823] iwl4965 0000:03:00.0:
device EEPROM VER=0x36, CALIB=0x5
Dec  3 10:18:02 (none) klogd: [    1.841597] iwl4965 0000:03:00.0:
Tunable channels: 11 802.11bg, 13 802.11a channels
Dec  3 10:18:02 (none) klogd: [    1.843495] iwl4965 0000:03:00.0: irq
31 for MSI/MSI-X
Dec  3 10:18:02 (none) klogd: [    1.843839] iwl4965 0000:03:00.0:
Direct firmware load for iwlwifi-4965-2.ucode failed with error -2
Dec  3 10:18:02 (none) klogd: [    1.845598] iwl4965 0000:03:00.0:
request for firmware file 'iwlwifi-4965-2.ucode' failed.
Dec  3 10:18:02 (none) klogd: [    1.847392] iwl4965 0000:03:00.0: no
suitable firmware found!

turning loadable kernel modules back on works
