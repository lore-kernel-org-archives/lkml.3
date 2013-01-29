Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3A2CVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:21:24 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57693 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3A2CVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <51072EDA.2000704@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
	<1358525267-14268-5-git-send-email-jiang.liu@huawei.com>
	<3500982.MUDp6kKU3R@vostro.rjw.lan>
	<CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
	<CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
	<CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com>
	<CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
	<CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
	<CAE9FiQU84OSQrQJEGAQTDzVv8kGCi+fmgM8+ycoMXMUfHsNe-g@mail.gmail.com>
	<51072EDA.2000704@huawei.com>
Date: Mon, 28 Jan 2013 18:21:19 -0800
X-Google-Sender-Auth: XTsohjsAZ2lNPPvrwGNk30YR4Ao
Message-ID: <CAE9FiQVeFO5X0cRgty6T8OeLKpVweWw+cSk0eygC8ivJMAPM6A@mail.gmail.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <liuj97@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 6:07 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
>         Could we use quirk to auto-disable PCIe native hotplug for
> problematic platforms?

that is some kind of boot command line way?

Yinghai
