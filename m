Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbbAIWZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:25:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAIWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:25:03 -0500
Date: Fri, 9 Jan 2015 14:25:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz,
        jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch,
        andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com,
        grant.likely@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sprdlinux@freelists.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v4 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Message-ID: <20150109222501.GA10102@kroah.com>
References: <sc9836v4>
 <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1417692860-18841-6-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417692860-18841-6-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 07:34:20PM +0800, Chunyan Zhang wrote:
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -247,4 +247,7 @@
>  /* MESON */
>  #define PORT_MESON	109
>  
> +/* SPRD SERIAL  */
> +#define PORT_SPRD       110

Please use a tab here, like all other entries have.
