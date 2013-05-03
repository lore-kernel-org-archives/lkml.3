Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093Ab3ECKn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:43:26 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61385 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851Ab3ECKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130503085944.69ef751e@crub>
References: <1367407689-16252-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130502171452.GP1960@intel.com>
	<CAF0T0X7XBuL7a=8zwqMnLDB04-Tf=qhCLPZ4T29yNdN6mP5S2A@mail.gmail.com>
	<20130503085944.69ef751e@crub>
Date: Fri, 3 May 2013 14:43:23 +0400
Message-ID: <CAF0T0X5cRMvoZKQQUkQHTLjbzz1xi_1pvUiywsKb5BGvyMGvpg@mail.gmail.com>
Subject: Re: [PATCH 1/1] powerpc: mpc512x_dma: add support for data transfers
 between memory and i/o memory
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anatolij,

> Note that there is a patch for .device_prep_slave_sg() operation
> for this driver as part of this series:
> https://patchwork.kernel.org/patch/2368581/
> https://patchwork.kernel.org/patch/2368591/
Thanks, I haven't seen that patch.
It's certainly what my SCLPC device driver needs
(http://patchwork.ozlabs.org/patch/241010/).
I will send the second version of it which uses .device_prep_slave_sg().

> maybe you can reuse and improve it.
> Anatolij
Should I propose my additions at https://patchwork.kernel.org/patch/2368591/ ?

Best regards,
Alexander
