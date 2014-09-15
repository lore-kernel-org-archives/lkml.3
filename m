Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaIOSJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:09:15 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46405 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaIOSJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:09:13 -0400
Message-ID: <54172B42.1060606@cogentembedded.com>
Date: Mon, 15 Sep 2014 21:09:06 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/9] usb: rename phy to usb_phy in HCD
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com> <1410777309-12552-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1410777309-12552-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/15/2014 1:35 PM, Antoine Tenart wrote:

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
>   drivers/usb/misc/lvstest.c    |  8 ++++----

    I have already re-posted this patch (adding it to my generic PHY patch to 
form a short series) with this file added, and CC'ed you. I haven't heard any 
protest (perhaps I missed it?), why reiterate with this patch instead of 
basing the patchset on my most recent posting?

>   include/linux/usb/hcd.h       |  2 +-
>   10 files changed, 49 insertions(+), 49 deletions(-)

WBR, Sergei

