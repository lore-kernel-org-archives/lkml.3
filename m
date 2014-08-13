Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaHMVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:36:08 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:46314 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaHMVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
Date: Wed, 13 Aug 2014 23:36:05 +0200
Message-ID: <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com>
Subject: Re: Kernel 3.16.0 USB crash
From: Matt <jackdachef@gmail.com>
To: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Cc: kraxel@redhat.com, hdegoede@redhat.com, sarah.a.sharp@linux.intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:24 PM, Matt <jackdachef@gmail.com> wrote:
> Hi Claudio,
>
> this issue is clearly caused by UAS.
>
> if
>
> zcat /proc/config.gz | grep UAS
> # CONFIG_USB_UAS is not set
>
> is de-selected, everything's fine
>
> when this is selected (usb is compiled as a module here)
>
> the system crashes or hardlocks as soon as an USB 3.0 capable drive is
> connected.
>
> During bootup the system crashes as soon as the kernel module is loaded.
>
> This happened for me with 3.15.6 and 3.16.0 kernel (and 3.16-rc6).
>
> I've a different chipset but the symptoms are similar:
>
> 00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
> Family USB xHCI (rev 05)
>
>
> So the only solution to work with newer kernels right now is to
> de-select that option and re-compile the kernel. It doesn't help fix
> the problem but at least it mitigates the issues for now (crash).
>
>
> Regards
>
> Matt

Adding some relevant CCs
