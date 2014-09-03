Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaICWGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:06:55 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:37745 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbaICWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:06:51 -0400
Message-ID: <540790F7.8040006@cogentembedded.com>
Date: Thu, 04 Sep 2014 02:06:47 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/9] usb: rename phy to usb_phy in HCD
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com> <1409730040-14200-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1409730040-14200-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/03/2014 11:40 AM, Antoine Tenart wrote:

> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>   drivers/usb/chipidea/host.c   |  2 +-
>   drivers/usb/core/hcd.c        | 20 ++++++++++----------
>   drivers/usb/core/hub.c        |  8 ++++----
>   drivers/usb/host/ehci-fsl.c   | 16 ++++++++--------
>   drivers/usb/host/ehci-hub.c   |  2 +-
>   drivers/usb/host/ehci-msm.c   |  4 ++--
>   drivers/usb/host/ehci-tegra.c | 16 ++++++++--------
>   drivers/usb/host/ohci-omap.c  | 20 ++++++++++----------
>   include/linux/usb/hcd.h       |  2 +-
>   9 files changed, 45 insertions(+), 45 deletions(-)

    It looks like you left out drivers/usb/misc/lvstest.c...

WBR, Sergei

