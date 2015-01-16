Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbbAPLCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:02:23 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:43023 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbbAPLCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:02:21 -0500
Date: Fri, 16 Jan 2015 13:02:09 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de,
        gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com,
        jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de,
        florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com,
        hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com,
        Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com,
        shawn.guo@linaro.org, lea.yan@linaro.org,
        jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Message-ID: <20150116110209.GA2299@tarshish>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chunyan Zhang,

On Fri, Jan 16, 2015 at 06:00:11PM +0800, Chunyan Zhang wrote:
> +		if (uart_handle_sysrq_char(port, ch))
> +			continue;

You don't define SUPPORT_SYSRQ, so uart_handle_sysrq_char has no effect. See 
include/linux/serial_core.h.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
