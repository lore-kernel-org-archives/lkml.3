Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaK3Vn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:43:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65191 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaK3Vnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:43:55 -0500
MIME-Version: 1.0
In-Reply-To: <1417359787-10138-45-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com> <1417359787-10138-45-git-send-email-mst@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 30 Nov 2014 21:43:23 +0000
Message-ID: <CA+V-a8t6Gp8XyCAM8DVFrhyJzN5wdEMv8nn59mCP1FP6QQLwXg@mail.gmail.com>
Subject: Re: [PATCH v7 44/46] virtio_scsi: export to userspace
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        Andy Grover <agrover@redhat.com>,
        stephen hemminger <stephen@networkplumber.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Anup Patel <anup.patel@linaro.org>,
        linux-api <linux-api@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thanks for the patch.

On Sun, Nov 30, 2014 at 3:12 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> Replace uXX by __uXX and _packed by __attribute((packed))
> as seems to be the norm for userspace headers.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>  include/uapi/linux/virtio_scsi.h | 74 ++++++++++++++++++++--------------------
>  include/uapi/linux/Kbuild        |  1 +

Probably worth making a separate patch for this ? as it doesnt
match with patch description aswel.

Apart from that patch looks good.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
