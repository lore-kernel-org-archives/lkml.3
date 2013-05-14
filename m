Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3ENMmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:42:06 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:55938 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3ENMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:42:04 -0400
Message-ID: <51923114.2070701@gmail.com>
Date: Tue, 14 May 2013 20:41:56 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2, part 1 5/9] ACPI, PCI: remove unused global list acpi_pci_roots
 in pci_root.c
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com> <1368461313-4371-6-git-send-email-jiang.liu@huawei.com> <1598495.v92I2Ljz9W@vostro.rjw.lan>
In-Reply-To: <1598495.v92I2Ljz9W@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14 May 2013 07:28:45 AM CST, Rafael J. Wysocki wrote:
> On Tuesday, May 14, 2013 12:08:29 AM Jiang Liu wrote:
>> Now the global list acpi_pci_roots pci_root.c is useless, remove it.
>
> Well, are patches [1-4/9] needed for that or does it apply without them?
Hi Rafael,
       This two patches have no dependency on others.
       Thanks!

>
> Rafael
>
>

