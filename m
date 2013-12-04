Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3LDH47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:56:59 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52274 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3LDH46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:56:58 -0500
MIME-Version: 1.0
In-Reply-To: <1386140747-16043-1-git-send-email-zhouqiao@marvell.com>
References: <1386140747-16043-1-git-send-email-zhouqiao@marvell.com>
Date: Tue, 3 Dec 2013 23:56:56 -0800
Message-ID: <CAPcyv4iMFCmQVbqphkcuKTsMg-YzApyPM2DnO-JY3htLhnrMXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: mmp: build sram driver alone
From: Dan Williams <dan.j.williams@intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: eric.y.miao@gmail.com, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 11:05 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
> sram driver can be used by many chips besides CPU_MMP2, and so build
> it alone.
>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> ---
>  arch/arm/mach-mmp/Kconfig  |    5 +++++
>  arch/arm/mach-mmp/Makefile |    3 ++-
>  2 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> index ebdda83..6a6597c 100644
> --- a/arch/arm/mach-mmp/Kconfig
> +++ b/arch/arm/mach-mmp/Kconfig
> @@ -136,4 +136,9 @@ config USB_EHCI_MV_U2O
>         help
>           Enables support for OTG controller which can be switched to host mode.
>
> +config MMP_SRAM
> +       bool
> +       help
> +         Select code specific to sram.
> +

No need for help text for something that is selected, and might as
well squash this with patch 2.
