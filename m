Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3LECA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:00:57 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43104 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3LECA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <1386207381-28197-2-git-send-email-zhouqiao@marvell.com>
References: <1386207381-28197-1-git-send-email-zhouqiao@marvell.com>
	<1386207381-28197-2-git-send-email-zhouqiao@marvell.com>
Date: Wed, 4 Dec 2013 18:00:54 -0800
Message-ID: <CAPcyv4g3rLCtxUBUV-REBvTP6m2ZGXUs4rgjPRr6qbq8OccUuw@mail.gmail.com>
Subject: Re: [PATCH V2] arm: mmp: build sram driver alone
From: Dan Williams <dan.j.williams@intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 5:36 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> sram driver can be used by many chips besides CPU_MMP2, and so build
> it alone. Also need to select MMP_SRAM for MMP_TDMA driver.
>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> ---

Looks good, thanks for fixing it up.

--
Dan
