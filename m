Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaCXTO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:14:56 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58965 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbaCXTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:14:54 -0400
Message-ID: <53308428.2090003@iki.fi>
Date: Mon, 24 Mar 2014 21:14:48 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>, linux-media@vger.kernel.org
Subject: Re: randconfig build error with next-20140324, in drivers/media/tuners/e4000.c
References: <CA+r1ZhjFY3eBZwcfjQZqBO4iPNMZLUnky0+_5gc=FtdEbGLByg@mail.gmail.com>
In-Reply-To: <CA+r1ZhjFY3eBZwcfjQZqBO4iPNMZLUnky0+_5gc=FtdEbGLByg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.190.236
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already fixed
https://patchwork.linuxtv.org/patch/23115/

On 24.03.2014 20:38, Jim Davis wrote:
> Building with the attached random configuration file,
>
> warning: (DVB_USB_RTL28XXU) selects MEDIA_TUNER_E4000 which has unmet
> direct dependencies ((MEDIA_ANALOG_TV_SUPPORT ||
> MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && MEDIA_SUPPORT &&
> I2C && VIDEO_V4L2)
> warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has
> unmet direct dependencies (NET && INET && NETFILTER)
> warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
>
> drivers/built-in.o: In function `e4000_remove':
> e4000.c:(.text+0x30570f): undefined reference to `v4l2_ctrl_handler_free'
> drivers/built-in.o: In function `e4000_probe':
> e4000.c:(.text+0x306085): undefined reference to `v4l2_ctrl_handler_init_class'
> e4000.c:(.text+0x3060ae): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x3060e1): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x3060fd): undefined reference to `v4l2_ctrl_auto_cluster'
> e4000.c:(.text+0x306126): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x306156): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x306172): undefined reference to `v4l2_ctrl_auto_cluster'
> e4000.c:(.text+0x30619b): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x3061cb): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x3061e7): undefined reference to `v4l2_ctrl_auto_cluster'
> e4000.c:(.text+0x306210): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x306240): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x30625c): undefined reference to `v4l2_ctrl_auto_cluster'
> e4000.c:(.text+0x306285): undefined reference to `v4l2_ctrl_new_std'
> e4000.c:(.text+0x3062a0): undefined reference to `v4l2_ctrl_handler_free'
> make: *** [vmlinux] Error 1
>


-- 
http://palosaari.fi/
