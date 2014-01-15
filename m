Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaAOVuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:50:32 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:61071 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaAOVua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <126550032.20140115203605@eikelenboom.it>
References: <1389499841-6097-1-git-send-email-linux@eikelenboom.it>
 <XNM1$9$0$4$$3$3$7$A$9006858U52d4d109@hitachi.com> <6310129377.20140114162641@eikelenboom.it>
 <XNM1$9$0$4$$3$3$7$A$9006860U52d614ca@hitachi.com> <126550032.20140115203605@eikelenboom.it>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Jan 2014 14:50:09 -0700
Message-ID: <CAErSpo7Bjo3rVCnuf9fkKc=T33Z5ZBzS+nHOBqDDKt1j4u0yWg@mail.gmail.com>
Subject: Re: In "pci_fixup_video" check if this is or should be the primary
 video devi
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: eiichiro.oiwa.nm@hitachi.com, Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:36 PM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
> ...
> And that's just what my patch does ..
>
> +       if (!vga_default_device() || pdev == vga_default_device()) {
>
> If we don't know the vga_default_device ... because we don't have that knowlegde
> or
> if this is actually the vga_default_device  ... because we do have that knowledge ..
>
> and only then .. run the fixup code and set this device as the vga_default_device
>
>
> So this change actually makes the code adhere to the comment already above it .. saying it should only be applied to the vga_default_device aka
> boot video device.
>
> Also added Bjorn and linux-pci to the CC .. should have done that right away ..
> sorry for that.

Can you resend your patch to linux-pci?  I don't think it made it there.

Bjorn
