Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3GPM07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:26:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46267 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3GPM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:26:57 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: balbi@ti.com
Cc: Paul Zimmerman <paul.zimmerman@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com
Subject: Re: DWC2 and/or S3C-HSOTG for STA2X11 board
Date: Tue, 16 Jul 2013 14:27:43 +0200
Message-ID: <2703444.NGzofRFyoM@harkonnen>
User-Agent: KMail/4.10.4 (Linux/3.9.9-201.fc18.x86_64; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130716120425.GA32038@arwen.pp.htv.fi>
References: <38175373.Cq6zxae9tO@harkonnen> <20130716120425.GA32038@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Felipe

[add CC Giancarlo from ST]

On Tuesday 16 July 2013 15:04:25 Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jul 16, 2013 at 02:01:33PM +0200, Federico Vaga wrote:
> > Hello,
> > 
> > I have an x86 board made by STMicroelectronics (STA2X11) with the Synopsis
> > USB-OTG DesignWare 2 on it and connected through the PCI-e bus.
> > 
> > I know that there are two drivers for the same controller:
> >    (host)   drivers/staging/dwc2/*
> >    (device) drivers/usb/gadget/s3c-hsotg.{c|h}
> > 
> > So, at the moment I cannot have a board with both host/device working at
> > the same time. I have to choose to use the block as device or host,
> > right?
> > 
> > I know that the plan is to merge the s3c-hsotg in the dwc2 driver
> > (https://lwn.net/Articles/540283/). Are still accepted patch to s3c-hsotg?
> > Or it is work in progress right now (soon), so it is better to wait after
> > the merge?
> > 
> > In order to use the s3c-hsotg I must implement a PCI wrapper that uses
> > this
> > driver. It will be accepted in the kernel even if it will be removed
> > sooner or later because of the driver merge?
> 
> currently s3c-hsotg has too much knowledge of the Samsung platform. My
> suggestion would be to help dwc2 get in better shape. It should be
> rather easy to support your board since that already has a PCI wrapper
> driver.
> 
> So, stick to host only for now, help clean up dwc2 and move it out of
> staging, then later it should be fairly simple to merge the device side
> in it.

Is there something like a TODO list of dwc2 known problems?

-- 
Federico Vaga
