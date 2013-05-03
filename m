Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab3ECG7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:59:54 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56235 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3ECG7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:59:53 -0400
X-Auth-Info: WS/ybI0i5XbvtIIBKQSKxWZCYMpguKxbdQJo+TrJQSc=
Date: Fri, 3 May 2013 08:59:44 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 1/1] powerpc: mpc512x_dma: add support for data
 transfers between memory and i/o memory
Message-ID: <20130503085944.69ef751e@crub>
In-Reply-To: <CAF0T0X7XBuL7a=8zwqMnLDB04-Tf=qhCLPZ4T29yNdN6mP5S2A@mail.gmail.com>
References: <1367407689-16252-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130502171452.GP1960@intel.com>
	<CAF0T0X7XBuL7a=8zwqMnLDB04-Tf=qhCLPZ4T29yNdN6mP5S2A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013 10:28:02 +0400
Alexander Popov <a13xp0p0v88@gmail.com> wrote:

> Hello Vinod,
> 
> Thanks for the review.
> I will return with improved and tested version 2.

Note that there is a patch for .device_prep_slave_sg() operation
for this driver as part of this series:
https://patchwork.kernel.org/patch/2368581/
https://patchwork.kernel.org/patch/2368591/

maybe you can reuse and improve it.

Thanks,

Anatolij
