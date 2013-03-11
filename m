Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3CKVhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:37:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41056
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470Ab3CKVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:37:11 -0400
Message-ID: <1363037814.3155.1.camel@smoke>
Subject: Re: [PATCH] powerpc: Use PTR_RET instead of IS_ERR/PTR_ERR
From: Geoff Levand <geoff@infradead.org>
To: Adrian-Leonard Radu <ady8radu@gmail.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
        cascardo@linux.vnet.ibm.com, akinobu.mita@gmail.com,
        fweisbec@gmail.com, john.stultz@linaro.org, rostedt@goodmis.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org
Date: Mon, 11 Mar 2013 14:36:54 -0700
In-Reply-To: <1362920820-11073-1-git-send-email-ady8radu@gmail.com>
References: <1362920820-11073-1-git-send-email-ady8radu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-10 at 15:07 +0200, Adrian-Leonard Radu wrote:
> Signed-off-by: Adrian-Leonard Radu <ady8radu@gmail.com>
> ---
>  arch/powerpc/kernel/iommu.c          |    2 +-
>  arch/powerpc/kernel/time.c           |    4 +---
>  arch/powerpc/platforms/ps3/time.c    |    4 +---
>  arch/powerpc/sysdev/rtc_cmos_setup.c |    5 +----
>  4 files changed, 4 insertions(+), 11 deletions(-)

ps3 part looks OK, thanks.

Acked-by: Geoff Levand <geoff@infradead.org>


