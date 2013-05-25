Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3EYRnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:43:52 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34922 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab3EYRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <1369503576-22271-2-git-send-email-prabhakar.csengg@gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com> <1369503576-22271-2-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 25 May 2013 23:13:29 +0530
Message-ID: <CA+V-a8sAXXq=gBO_uDsOS1MonXJan+mpBwo15tvp+wR40kAMKA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Sat, May 25, 2013 at 11:09 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> remove init_enable from ths7303 pdata as it is being dropped
> from ths7303_platform_data.
>
Can you please ack this patch as I intend to take this patch via media
tree.

Regards,
--Prabhakar Lad
