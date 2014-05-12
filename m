Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaELNKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:10:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35244 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaELNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:10:18 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.68.234]
In-Reply-To: <1399560990-1402858-18-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-18-git-send-email-arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 12 May 2014 16:09:56 +0300
Message-ID: <CAK=WgbZ1c6=_MT0tb0X_E58ia=bSSGc5o_kHV_g0jJuDCtB5oA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: da8xx: don't select CMA on no-MMU
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, May 8, 2014 at 5:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> We can only use CMA on systems that have an MMU, because of
> the requirement to use memory migration. NOMMU systems are
> rather constrained to start with, but it seems reasonable
> to assume that DMA allocations can still succeed in the
> constrained case for remoteproc on NOMMU, so this patch
> changes the da8xx implementation to not rely on CMA when
> the MMU is disabled.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Robert Tivy <rtivy@ti.com>
> ---

Would you like me to pick this via the remoteproc tree or are you
planning to route this set elsewhere anyway?

Thanks,
Ohad.
