Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3E0Chy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:37:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37923 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0Chx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:37:53 -0400
Message-ID: <51A2C6DD.208@huawei.com>
Date: Mon, 27 May 2013 10:37:17 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: <hverkuil@xs4all.nl>, <matthew.garrett@nebula.com>,
        <jejb@parisc-linux.org>, <deller@gmx.de>, <richardcochran@gmail.com>,
        <ptyser@xes-inc.com>, <sameo@linux.intel.com>, <bhelgaas@google.com>,
        <JBottomley@parallels.com>, <oliver@neukum.org>, <aliakc@web.de>,
        <samuel@sortiz.org>, <davem@davemloft.net>, <chas@cmf.nrl.navy.mil>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH 00/25] Convert to module_pci_driver replace init/exit
References: <1369621702-12920-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369621702-12920-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, only 24!

On 2013/5/27 10:28, Libo Chen wrote:
> use module_pci_driver instead of init/exit, make code clean.
> 
> Libo Chen (25):
>   drivers/scsi/a100u2w: Convert to module_pci_driver replace init/exit
>   drivers/scsi/dc395x: Convert to module_pci_driver
>   drivers/scsi/dmx3191d: Convert to module_pci_driver
>   drivers/scsi/initio: Convert to module_pci_driver
>   drivers/scsi/mvumi: Convert to module_pci_driver
>   drivers/net/irda/donauboe: Convert to module_pci_driver
>   drivers/ide/delkin_cb: Convert to module_pci_driver
>   drivers/atm/he: Convert to module_pci_driver
>   drivers/pci/ioapic: Convert to module_pci_driver
>   drivers/mfd/lpc_ich: Convert to module_pci_driver
>   drivers/ptp/ptp_pch: Convert to module_pci_driver
>   drivers/memstick/host/r592: Convert to module_pci_driver
>   drivers/parisc/superio: Convert to module_pci_driver

please, drop it had been changed in upstream.

>   drivers/uwb/whci: Convert to module_pci_driver
>   drivers/platform/x86/intel_ips: Convert to module_pci_driver
>   drivers/memstick/host/jmb38x_ms: Convert to module_pci_driver
>   drivers/media/pci/mantis/mantis_cards: Convert to module_pci_driver
>   drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver
>   drivers/media/pci/mantis/hopper_cards: Convert to module_pci_driver
>   drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver2
>   drivers/media/pci/pluto2/pluto2: Convert to module_pci_driver
>   drivers/media/pci/pt1/pt1: Convert to module_pci_driver
>   drivers/media/radio/radio-maxiradio: Convert to module_pci_driver
>   drivers/pcmcia/pd6729: Convert to module_pci_driver
>   drivers/pcmcia/yenta_socket: Convert to module_pci_driver
> 
>  drivers/atm/he.c                        |   13 +------------
>  drivers/ide/delkin_cb.c                 |   13 +------------
>  drivers/media/pci/b2c2/flexcop-pci.c    |   13 +------------
>  drivers/media/pci/dm1105/dm1105.c       |   13 +------------
>  drivers/media/pci/mantis/hopper_cards.c |   13 +------------
>  drivers/media/pci/mantis/mantis_cards.c |   13 +------------
>  drivers/media/pci/pluto2/pluto2.c       |   13 +------------
>  drivers/media/pci/pt1/pt1.c             |   15 +--------------
>  drivers/media/radio/radio-maxiradio.c   |   13 +------------
>  drivers/memstick/host/jmb38x_ms.c       |   13 +------------
>  drivers/memstick/host/r592.c            |   13 +------------
>  drivers/mfd/lpc_ich.c                   |   13 +------------
>  drivers/net/irda/donauboe.c             |   15 +--------------
>  drivers/parisc/superio.c                |    1 -
>  drivers/pci/ioapic.c                    |   13 +------------
>  drivers/pcmcia/pd6729.c                 |   13 +------------
>  drivers/pcmcia/yenta_socket.c           |   16 +---------------
>  drivers/platform/x86/intel_ips.c        |   13 +------------
>  drivers/ptp/ptp_pch.c                   |   18 +-----------------
>  drivers/scsi/a100u2w.c                  |   12 +-----------
>  drivers/scsi/dc395x.c                   |   24 +-----------------------
>  drivers/scsi/dmx3191d.c                 |   13 +------------
>  drivers/scsi/initio.c                   |   13 +------------
>  drivers/scsi/mvumi.c                    |   20 +-------------------
>  drivers/uwb/whci.c                      |   13 +------------
>  25 files changed, 24 insertions(+), 318 deletions(-)
> 
> 
> 
> .
> 


