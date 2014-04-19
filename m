Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaDSLA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:00:26 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:60522 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaDSLAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:00:18 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2014 07:00:18 EDT
Date: Sat, 19 Apr 2014 13:52:26 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com
Subject: Re: [PATCH v2 05/13] extcon: extcon-class: improve extcon client API
Message-ID: <20140419105225.GB976@ambient.musicnaut.iki.fi>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
 <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 14, 2014 at 01:46:16PM +0200, Robert Baldyga wrote:
>  	dev_info(&pdev->dev,
> -		 "OMAP USB OTG controller rev %d.%d (%s, id=%d, vbus=%d)\n",
> -		 (rev >> 4) & 0xf, rev & 0xf, config->extcon, otg_dev->id,
> +		 "OMAP USB OTG controller rev %d.%d (id=%d, vbus=%d)\n",
> +		 (rev >> 4) & 0xf, rev & 0xf, otg_dev->id,
>  		 otg_dev->vbus);

This change is unrelated to the patch and not needed.

A.
