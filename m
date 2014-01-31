Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaAaVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:05:14 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754142AbaAaVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:05:12 -0500
Date: Fri, 31 Jan 2014 22:05:07 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Matt Ranostay <mranostay@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com
Subject: Re: [PATCH 2/2] iio: Add AS3935 lightning sensor support
Message-ID: <20140131210507.GC3036@piout.net>
References: <1391076673-5623-1-git-send-email-mranostay@gmail.com>
 <1391076673-5623-2-git-send-email-mranostay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391076673-5623-2-git-send-email-mranostay@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 30/01/2014 at 02:11:13 -0800, Matt Ranostay wrote :
> AS3935 chipset can detect lightning strikes and reports those
> back as events and the esimated distance to the storm.
> 
> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
> ---
>  .../devicetree/bindings/iio/distance/as3935.txt    |  25 ++

Maybe I'm wrong but wasn't the agreement that the bindings documentation
has to be sent separately to the devicetree mailing list ?

>  drivers/iio/Kconfig                                |   1 +
>  drivers/iio/Makefile                               |   1 +
>  drivers/iio/distance/Kconfig                       |  19 +
>  drivers/iio/distance/Makefile                      |   6 +
>  drivers/iio/distance/as3935.c                      | 459 +++++++++++++++++++++
>  6 files changed, 511 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/distance/as3935.txt
>  create mode 100644 drivers/iio/distance/Kconfig
>  create mode 100644 drivers/iio/distance/Makefile
>  create mode 100644 drivers/iio/distance/as3935.c

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
