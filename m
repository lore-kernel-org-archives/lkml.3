Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3LEJGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:06:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48309 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3LEJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <003101ceefb5$dc1b0380$94510a80$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<003101ceefb5$dc1b0380$94510a80$%han@samsung.com>
Date: Thu, 5 Dec 2013 17:06:33 +0800
Message-ID: <CAAb+SYZh1KXHQV0GSeFtOkYC=3acZYRvSnqf-VR2rH=T69nWxg@mail.gmail.com>
Subject: Re: [PATCH 28/39] staging: remove DEFINE_PCI_DEVICE_TABLE macro
From: ZHAO Gang <gamerh2o@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 7:26 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>

I think you misunderstood the checkpatch.pl warning, it tells you what
to do, not what not to do.

WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id

This means use DEFINE_PCI_DEVICE_TABLE to replace struct
pci_device_id, not reverse.
