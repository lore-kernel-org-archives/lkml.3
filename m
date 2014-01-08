Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaAHHrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:47:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaAHHq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:46:57 -0500
Date: Wed, 8 Jan 2014 10:47:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pisa@cmp.felk.cvut.cz
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
Message-ID: <20140108074701.GP5443@mwanda>
References: <1389133497-10149-1-git-send-email-lisovy@gmail.com>
 <1389133497-10149-2-git-send-email-lisovy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389133497-10149-2-git-send-email-lisovy@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:24:57PM +0100, Rostislav Lisovy wrote:
> This patch adds Comedi driver for Humusoft MF634 (PCIe) and
> MF624 (PCI) data acquisition cards. The legacy card Humusoft
> MF614 is not supported. More info about the cards may be found
> at http://humusoft.cz/produkty/datacq/
> The driver was tested with both cards. Everything seems to work
> properly. Just the basic functionality of the card (DIO, ADC, DAC)
> is supported by this driver.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> 
>  create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
> 

There should be a "---" after the Signed-off-by line and before the
diffstat "create mode 100644 drivers/staging/comedi/drivers/mf6x4.c"
line.  Otherwise, the diffstat gets included in the changelog.

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
create mode 100644 drivers/staging/comedi/drivers/mf6x4.c

It's a small thing...  I almost feel bad for pointing it out.

regards,
dan carpenter

