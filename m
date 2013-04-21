Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3DUN4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 09:56:37 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58358 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3DUN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 09:56:36 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.125.78]
In-Reply-To: <1366133126-5448-1-git-send-email-s-anna@ti.com>
References: <1366133126-5448-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 21 Apr 2013 16:56:15 +0300
Message-ID: <CAK=WgbbM_Cphbvcqh991oEmrFTsbWn4hDkyA4U9P74UrXgq+Xw@mail.gmail.com>
Subject: Re: [PATCH 2/2] rpmsg: fix kconfig dependencies for VIRTIO
To: Suman Anna <s-anna@ti.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 8:25 PM, Suman Anna <s-anna@ti.com> wrote:
> rpmsg configuration selects VIRTIO, but VIRTIO is now
> subordinate to VIRTUALIZATION. RPMSG is currently selected
> by OMAP_REMOTEPROC, and the dependency warning is not seen
> with the fix in remoteproc config, but the kconfig menu
> hierarchy dependency has to be honored nevertheless.
>
> warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)
> warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

Applied, thanks!
