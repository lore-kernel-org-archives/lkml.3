Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab3DGWTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:19:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33452 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab3DGWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:19:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5A0=TxfAiqUnL4dihu5y1Hq5n8K9zgA973Sf4Pi_Haq2Q@mail.gmail.com>
References: <CAAAP30FOjuXNTZb-NarVpfU80Ad60=KbXN8x_EoUb7BUuEKmwA@mail.gmail.com>
	<CAOMZO5A0=TxfAiqUnL4dihu5y1Hq5n8K9zgA973Sf4Pi_Haq2Q@mail.gmail.com>
Date: Sun, 7 Apr 2013 19:19:29 -0300
Message-ID: <CAAAP30FuQE4Lu9_+HOQmBY1V06Hfn==1j9FfzFuAH1uD2sqdng@mail.gmail.com>
Subject: Re: IMX23 usb instability on 3.9-rc5
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        alexander.shishkin@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        fabio.estevam@freescale.com, Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 4:44 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Maybe bad DDR initialization? Are using U-boot or bootlets to setup the DDR?
>
> What is your DDR frequency: 133 or 96MHz? I saw some posts in the
> olimex forum that people had to run it at 96MHz to get stable
> operation.

Thanks Fabio,

That seems to be the case. I did two of the mods sugested on olimex forums.
1) Remove R17.
2) Drop DDR speed to 96MHZ.

The first improved the behavior a lot, but still have crashes. The
second have almost eliminated them.

On Sat, Apr 6, 2013 at 4:44 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Alexandre,
>
> On Sat, Apr 6, 2013 at 4:39 PM, Alexandre Pereira da Silva
> <aletes.xgr@gmail.com> wrote:
>> Hello,
>>
>> I am testing a usb key connected on a IMX23-Olinuxino board. The
>> kernel panics at heavy usb trafic. This was build with the mxs
>> defconfig
>>
>> This happens everytime with "dd if=/dev/sda of=/dev/null bs=4k". The
>> messages of the failure varies a lot from run to run.
>
> Maybe bad DDR initialization? Are using U-boot or bootlets to setup the DDR?
>
> What is your DDR frequency: 133 or 96MHz? I saw some posts in the
> olimex forum that people had to run it at 96MHz to get stable
> operation.
