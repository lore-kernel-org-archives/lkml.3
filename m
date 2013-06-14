Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3FNEnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 00:43:42 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40794 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3FNEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 00:43:40 -0400
MIME-Version: 1.0
In-Reply-To: <51BA98BF.5070403@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
	<51BA7B3D.1020402@huawei.com>
	<CAE9FiQX-jCZYPyxeHCp2h-6qx1GMyQYuaTk5JwZR6H1t4jRg9g@mail.gmail.com>
	<51BA8524.9050507@huawei.com>
	<CAN_LGv0AYvBpwQMcAkSqQVZHBA3Yfz=42_OGPxF032FQ-Ec36A@mail.gmail.com>
	<51BA98BF.5070403@huawei.com>
Date: Fri, 14 Jun 2013 10:43:39 +0600
Message-ID: <CAN_LGv1FNj-38=tpOg6itCJ3DQLw2TQaJJdGqRwtx9A9eVcxKw@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/14 Jiang Liu (Gerry) <jiang.liu@huawei.com>:

> What's the situation now? Could you please send out dmesgs\ioports\iomem?
> Thanks!

The requested information has been added to
https://bugzilla.kernel.org/show_bug.cgi?id=56531

The changes in pci_move_pcibios_add_bus_down.patch are not needed.

The radeon card in the dock station works after docking and restarting
the X server, and its HD audio device works, too. Just for
completeness, I have tested the CD-ROM drive, the USB adapters and the
Ethernet card - they all work. IOW, everything works after docking.

I did not test undocking, as that would surely hit
https://bugzilla.kernel.org/show_bug.cgi?id=59681 and the hda_intel
bug you mentioned in the first mail in this thread.

Note that, for the initial series of patches, I still don't have any
response to the lockdep warnings in
https://lkml.org/lkml/2013/6/13/398

-- 
Alexander E. Patrakov
