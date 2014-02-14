Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaBNNq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:46:27 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:59522 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBNNq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <s5hiosi3osp.wl%tiwai@suse.de>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
	<52FCFD92.7040109@hurleysoftware.com>
	<s5hiosi3osp.wl%tiwai@suse.de>
Date: Fri, 14 Feb 2014 21:46:25 +0800
Message-ID: <CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 1:28 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 13 Feb 2014 12:14:58 -0500,  Peter Hurley wrote:
> Apparently there's no maintainer but I've cc'ed people who might
> have a clue about this.

Peter ... thanks for pointer.

> On Fri, Feb 14, 2014 at 1:28 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Is it a Intel+Nvidia hybrid?  If so, does it happen even with
> CONFIG_VGA_SWITCHEROO=n?

It's not Intel+Nvidia. It's Intel Core i7-4600U 2.1 GHz, Intel HD Graphics 4400.

I checked my config. CONFIG_VGA_SWITCHEROO is not set.

On Fri, Feb 14, 2014 at 5:21 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> For what it's worth, I have a the X240's bigger brother --- a T540p
> (with intel graphics and the 3k panel) running 3.14-rc2, and
> suspend-to-ram is working without any problems on my laptop.

Interesting. Perhaps it's the USB options. I had these set to "y"

CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y

Again, These same config works find on X230. It's very strange. The
same hard disk (SSD) can suspend-to-ram on the X230 but not on the
X240. The X230 has i7-3520M vs X240 i7-4600U.

I've even tried with all the USB set to "n" and still couldn't S2D.
May be the graphic?

Thanks,
Jeff
