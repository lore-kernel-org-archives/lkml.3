Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaAHIfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:35:46 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:59698 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaAHIfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:35:39 -0500
Message-ID: <1389170133.10763.6.camel@umadbro>
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
From: Rostislav Lisovy <lisovy@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pisa@cmp.felk.cvut.cz
Date: Wed, 08 Jan 2014 09:35:33 +0100
In-Reply-To: <20140108074701.GP5443@mwanda>
References: <1389133497-10149-1-git-send-email-lisovy@gmail.com>
	 <1389133497-10149-2-git-send-email-lisovy@gmail.com>
	 <20140108074701.GP5443@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan;

On Wed, 2014-01-08 at 10:47 +0300, Dan Carpenter wrote:
> On Tue, Jan 07, 2014 at 11:24:57PM +0100, Rostislav Lisovy wrote:
> > This patch adds Comedi driver for Humusoft MF634 (PCIe) and
> > MF624 (PCI) data acquisition cards. The legacy card Humusoft
> > MF614 is not supported. More info about the cards may be found
> > at http://humusoft.cz/produkty/datacq/
> > The driver was tested with both cards. Everything seems to work
> > properly. Just the basic functionality of the card (DIO, ADC, DAC)
> > is supported by this driver.
> > 
> > Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> > 
> >  create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
> > 
> 
> There should be a "---" after the Signed-off-by line and before the
> diffstat "create mode 100644 drivers/staging/comedi/drivers/mf6x4.c"
> line.  Otherwise, the diffstat gets included in the changelog.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> ---
> create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
> 

You are right, my mistake. But even though there should be v3 patch
because I just realized there is an unnecessary comment in
mf6x4_detach() and MF6X4_DAC_CHANN_CNT constant is no more used.

Regards;
Rostislav Lisovy


