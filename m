Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3EWJgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:36:03 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:41063 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab3EWJf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <1368441547-6078-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368441547-6078-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 15:05:38 +0530
Message-ID: <CA+V-a8uNXG8BiQ1H=yHkUfKPVwK-jtu11H1fQ4Oo_unLULGY6Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/staging: davinci: vpfe: fix dependency for
 building the driver
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, May 13, 2013 at 4:09 PM, Lad Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> from commit 3778d05036cc7ddd983ae2451da579af00acdac2
> [media: davinci: kconfig: fix incorrect selects]
> VIDEO_VPFE_CAPTURE was removed but there was a negative
> dependancy for building the DM365 VPFE MC based capture driver
> (VIDEO_DM365_VPFE), This patch fixes this dependency by replacing
> the VIDEO_VPFE_CAPTURE with VIDEO_DM365_ISIF, so as when older DM365
> ISIF v4l driver is selected the newer media controller driver for
> DM365 isnt visible.
>
Do you plan to take this patch for 3.10 as a fix ? or for v3.11 ?

Regards,
--Prabhakar Lad
