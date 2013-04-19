Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694Ab3DSOjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:39:05 -0400
Received: from winds.org ([68.75.195.9]:32879 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030656Ab3DSOjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:39:04 -0400
Date: Fri, 19 Apr 2013 10:39:02 -0400 (EDT)
From: Byron Stanoszek <gandalf@winds.org>
To: David Herrmann <dh.herrmann@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: Standalone DRM application
In-Reply-To: <CANq1E4RGD+8QNAin+A-MZWAiqhLLvH+zG+gfhi7Vd6bYOuV75A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1304191037100.18789@winds.org>
References: <alpine.LNX.2.00.1304171605010.19898@winds.org> <CANq1E4RGD+8QNAin+A-MZWAiqhLLvH+zG+gfhi7Vd6bYOuV75A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, David Herrmann wrote:

> You can acquire/drop DRM-Master via drmSetMaster/drmDropMaster.
>
> If your DRM card is a PCI device, you can use the sysfs "boot_vga"
> attribute of the parent PCI device.
> (/sys/class/drm/card0/device/boot_vga)

David,

Thanks! That was exactly what I was looking for. Both ideas work wonderfully.

Regards,
  -Byron

