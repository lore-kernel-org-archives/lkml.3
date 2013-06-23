Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3FWVQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:16:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48319 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3FWVQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:16:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ACPI / dock / PCI: Fix problems with dock and PCI hotplug
Date: Sun, 23 Jun 2013 23:25:42 +0200
Message-ID: <1874788.JpoVk3cZ3x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAN_LGv3LZbp-7JE=Lxo+53GxWTQ_D6nJ=w+OnuQ3JkmWfXOhxg@mail.gmail.com>
References: <2737587.I0nULev1kj@vostro.rjw.lan> <CAN_LGv3LZbp-7JE=Lxo+53GxWTQ_D6nJ=w+OnuQ3JkmWfXOhxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 11:50:15 PM Alexander E. Patrakov wrote:
> 2013/6/23 Rafael J. Wysocki <rjw@sisk.pl>:
> > Alexander, I've modified patch [3/3] a bit since you have tested it.
> > The modifications shouldn't affect the behavior, but if you could re-test it,
> > that would be great.
> 
> Retested, everything works just as with the previous version of your patch.

Thanks for the confirmation!

Rafael

