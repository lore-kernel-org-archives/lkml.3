Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3ENMxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:53:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45854 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3ENMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:53:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Liu Jiang <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2, part 1 5/9] ACPI, PCI: remove unused global list acpi_pci_roots in pci_root.c
Date: Tue, 14 May 2013 15:01:38 +0200
Message-ID: <6812228.aa0vVeiYvi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51923114.2070701@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1598495.v92I2Ljz9W@vostro.rjw.lan> <51923114.2070701@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 14, 2013 08:41:56 PM Liu Jiang wrote:
> On Tue 14 May 2013 07:28:45 AM CST, Rafael J. Wysocki wrote:
> > On Tuesday, May 14, 2013 12:08:29 AM Jiang Liu wrote:
> >> Now the global list acpi_pci_roots pci_root.c is useless, remove it.
> >
> > Well, are patches [1-4/9] needed for that or does it apply without them?
> Hi Rafael,
>        This two patches have no dependency on others.

Can you please submit them separately, then?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
