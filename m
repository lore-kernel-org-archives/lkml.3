Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab3DFToo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 15:44:44 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:65535 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3DFTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 15:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAAAP30FOjuXNTZb-NarVpfU80Ad60=KbXN8x_EoUb7BUuEKmwA@mail.gmail.com>
References: <CAAAP30FOjuXNTZb-NarVpfU80Ad60=KbXN8x_EoUb7BUuEKmwA@mail.gmail.com>
Date: Sat, 6 Apr 2013 16:44:42 -0300
Message-ID: <CAOMZO5A0=TxfAiqUnL4dihu5y1Hq5n8K9zgA973Sf4Pi_Haq2Q@mail.gmail.com>
Subject: Re: IMX23 usb instability on 3.9-rc5
From: Fabio Estevam <festevam@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        alexander.shishkin@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        fabio.estevam@freescale.com, Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre,

On Sat, Apr 6, 2013 at 4:39 PM, Alexandre Pereira da Silva
<aletes.xgr@gmail.com> wrote:
> Hello,
>
> I am testing a usb key connected on a IMX23-Olinuxino board. The
> kernel panics at heavy usb trafic. This was build with the mxs
> defconfig
>
> This happens everytime with "dd if=/dev/sda of=/dev/null bs=4k". The
> messages of the failure varies a lot from run to run.

Maybe bad DDR initialization? Are using U-boot or bootlets to setup the DDR?

What is your DDR frequency: 133 or 96MHz? I saw some posts in the
olimex forum that people had to run it at 96MHz to get stable
operation.
