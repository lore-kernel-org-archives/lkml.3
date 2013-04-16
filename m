Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3DPK4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:56:33 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53919 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3DPK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 16 Apr 2013 16:26:10 +0530
Message-ID: <CA+V-a8tbVc4bsO0GE4vsmHfwpF4Q5z9Lzkya50VQpaKCOev02w@mail.gmail.com>
Subject: Re: [PATCH v2] media: davinci: vpif: align the buffers size to page
 page size boundary
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, Apr 16, 2013 at 4:24 PM, Prabhakar lad
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> with recent commit with id 068a0df76023926af958a336a78bef60468d2033
> which adds add length check for mmap, the application were failing to
> mmap the buffers.
>
> This patch aligns the the buffer size to page size boundary for both
> capture and display driver so the it pass the check.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---

Can you take this patch for v3.10 ?

Regards,
--Prabhakar
