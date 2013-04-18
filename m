Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966100Ab3DRHcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:32:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49447 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965925Ab3DRHcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <87wqs02uws.fsf@rustcorp.com.au>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<87wqs02uws.fsf@rustcorp.com.au>
Date: Thu, 18 Apr 2013 13:02:40 +0530
Message-ID: <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
> > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> >
> > This patch implements early printk support for virtio-mmio console devices without using any hypercalls.
>
> This makes some sense, though not sure that early console *read* makes
> much sense.  I can see the PCI version of this being useful as well.

Read can be useful for "mach-virt" which will have only virtio console
as a console device. Then if someone wants to have UEFI or any other
boot-loader emulation, which expects user to input few things, in that
case read might become handy.
>
>
> The spec definition for this will be interesting, because it can be used
> before the device is initialized (something which is generally
> verboten).
>
> Cheers,
> Rusty.

Thanks,
Pranav
