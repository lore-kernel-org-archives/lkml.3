Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JDTnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:43:37 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:36573 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3JDTnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:43:35 -0400
Message-ID: <1380915828.30424.0.camel@porter.coelho.fi>
Subject: Re: [GIT PULL] firmware: wl1251 firmware binary
From: Luca Coelho <luca@coelho.fi>
To: balbi@ti.com
Cc: dwmw2@infradead.org, ben@decadent.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Pavel Machek <pavel@denx.de>
Date: Fri, 04 Oct 2013 22:43:48 +0300
In-Reply-To: <20131004153246.GJ16059@radagast>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
	 <1380107096.4503.8.camel@porter.coelho.fi>
	 <1380107278.4503.9.camel@porter.coelho.fi>
	 <20130925132359.GE10746@radagast>
	 <1380116535.4503.19.camel@porter.coelho.fi>
	 <20130925135943.GI10746@radagast> <20131002125535.GL1476@radagast>
	 <1380862901.4265.33.camel@porter.coelho.fi>
	 <20131004153246.GJ16059@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 10:32 -0500, Felipe Balbi wrote:
> diff --git a/LICENCE.wl1251 b/LICENCE.wl1251
> new file mode 100644
> index 0000000..bd0f5f1
> --- /dev/null
> +++ b/LICENCE.wl1251
> @@ -0,0 +1,59 @@
> +Copyright (c) 2000 – 2013 Texas Instruments Incorporated
> +
> +All rights reserved not granted herein.
> +
> +Limited License.
> +
> +Texas Instruments Incorporated grants a world-wide, royalty-free, non-exclusive
> +license under copyrights and patents it now or hereafter owns or controls to
> +make, have made, use, import, offer to sell and sell ("Utilize") this software
> +subject to the terms herein.  With respect to the foregoing patent license,
> +such license is granted  solely to the extent that any such patent is necessary
> +to Utilize the software alone.  The patent license shall not apply to any
> +combinations which include this software, other than combinations with devices
> +manufactured by or for TI (“TI Devices”).  No hardware patent is licensed
> +hereunder.
> +
> +Redistributions must preserve existing copyright notices and reproduce this
> +license (including the above copyright notice and the disclaimer and (if
> +applicable) source code license limitations below) in the documentation and/or
> +other materials provided with the distribution
> +
> +Redistribution and use in binary form, without modification, are permitted
> +provided that the following conditions are met:
> +
> +*	No reverse engineering, decompilation, or disassembly of this software
> +	is permitted with respect to any software provided in binary form.
> +
> +*	any redistribution and use are licensed by TI for use only with TI
> +	Devices.
> +
> +*	Nothing shall obligate TI to provide you with source code for the
> +	software licensed and provided to you in object code.
> +
> +If software source code is provided to you, modification and redistribution of
> +the source code are permitted provided that the following conditions are met:
> +
> +*	any redistribution and use of the source code, including any resulting
> +	derivative works, are licensed by TI for use only with TI Devices.
> +
> +*	any redistribution and use of any object code compiled from the source
> +	code and any resulting derivative works, are licensed by TI for use
> +	only with TI Devices.
> +
> +Neither the name of Texas Instruments Incorporated nor the names of its
> +suppliers may be used to endorse or promote products derived from this software
> +without specific prior written permission.
> +
> +DISCLAIMER.
> +
> +THIS SOFTWARE IS PROVIDED BY TI AND TI’S LICENSORS "AS IS" AND ANY EXPRESS OR
> +IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> +MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
> +EVENT SHALL TI AND TI’S LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT,
> +INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> +LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
> +PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> +LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> +OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
> +ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> diff --git a/WHENCE b/WHENCE
> index aac3ba9..3a35670 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1712,6 +1712,24 @@ Licence: Redistributable. See LICENCE.tda7706-firmware.txt for details.
>  
>  --------------------------------------------------------------------------
>  
> +Driver: wl1251 - Texas Instruments 802.11 WLAN driver for WiLink4 chips
> +
> +File: ti-connectivity/wl1251-fw.bin
> +Version: 4.0.4.3.7
> +
> +File: ti-connectivity/wl1251-nvs.bin
> +
> +Licence: See LICENCE.wl1251 for details.
> +
> +The published NVS files are for testing only.  Every device needs to
> +have a unique NVS which is properly calibrated for best results.
> +
> +The driver expects to find the firmwares under a ti-connectivity subdirectory.
> +So if your system looks for firmwares in /lib/firmware, the firmwares for
> +wl12xx chips must be located in /lib/firmware/ti-connectivity/.
> +
> +--------------------------------------------------------------------------
> +
>  Driver: wl12xx - Texas Instruments 802.11 WLAN driver for WiLink6/7 chips
>  
>  File: ti-connectivity/wl1271-fw.bin
> diff --git a/ti-connectivity/wl1251-fw.bin b/ti-connectivity/wl1251-fw.bin
> new file mode 100644
> index 0000000..f89c983
> Binary files /dev/null and b/ti-connectivity/wl1251-fw.bin differ
> diff --git a/ti-connectivity/wl1251-nvs.bin b/ti-connectivity/wl1251-nvs.bin
> new file mode 100644
> index 0000000..2bf9c50
> Binary files /dev/null and b/ti-connectivity/wl1251-nvs.bin differ
> 

Looks good to me:

Acked-by: Luciano Coelho <luca@coelho.fi>

--
Luca.

