Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaIHNAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:00:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaIHNAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:00:10 -0400
Message-ID: <540DA87D.9000302@redhat.com>
Date: Mon, 08 Sep 2014 15:00:45 +0200
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Chun-Hao Lin <hau@realtek.com>, netdev@vger.kernel.org
CC: nic_swsd@realtek.com, linux-kernel@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH net-next v2] r8169:add support for RTL8168H and RTL8107E
References: <1408470844-30038-1-git-send-email-hau@realtek.com>
In-Reply-To: <1408470844-30038-1-git-send-email-hau@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.8.2014 19:54, Chun-Hao Lin wrote:
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 91652e7..c8375f6 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -52,6 +52,10 @@
>   #define FIRMWARE_8106E_2	"rtl_nic/rtl8106e-2.fw"
>   #define FIRMWARE_8168G_2	"rtl_nic/rtl8168g-2.fw"
>   #define FIRMWARE_8168G_3	"rtl_nic/rtl8168g-3.fw"
> +#define FIRMWARE_8168H_1	"rtl_nic/rtl8168h-1.fw"
> +#define FIRMWARE_8168H_2	"rtl_nic/rtl8168h-2.fw"
> +#define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
> +#define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"

Where are these new firmware files ^^^^ located? They are missing at 
git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

Ivan
