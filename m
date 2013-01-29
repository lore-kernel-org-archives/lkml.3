Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3A2Cpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:45:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32868 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3A2Cps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:45:48 -0500
Message-ID: <510737B0.40903@huawei.com>
Date: Tue, 29 Jan 2013 10:45:04 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <liuj97@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-5-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan> <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com> <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com> <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com> <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com> <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com> <CAE9FiQU84OSQrQJEGAQTDzVv8kGCi+fmgM8+ycoMXMUfHsNe-g@mail.gmail.com> <51072EDA.2000704@huawei.com> <CAE9FiQVeFO5X0cRgty6T8OeLKpVweWw+cSk0eygC8ivJMAPM6A@mail.gmail.com>
In-Reply-To: <CAE9FiQVeFO5X0cRgty6T8OeLKpVweWw+cSk0eygC8ivJMAPM6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-1-29 10:21, Yinghai Lu wrote:
> On Mon, Jan 28, 2013 at 6:07 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
>>         Could we use quirk to auto-disable PCIe native hotplug for
>> problematic platforms?
> 
> that is some kind of boot command line way?
We could negotiate between acpiphp and pciehp if those problematic 
platforms/chipsets could be identified by DMI info or PCI device ID.

> 
> Yinghai
> 
> 


