Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab3EOOnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:43:08 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48946 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290Ab3EOOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:43:04 -0400
Message-ID: <51939EF2.1070904@gmail.com>
Date: Wed, 15 May 2013 22:42:58 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2, part 2 01/18] PCI: introduce hotplug-safe PCI
 bus iterators
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com> <20130514170528.GA4030@kroah.com>
In-Reply-To: <20130514170528.GA4030@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 01:05 AM, Greg Kroah-Hartman wrote:
> On Wed, May 15, 2013 at 12:51:45AM +0800, Jiang Liu wrote:
>> +EXPORT_SYMBOL(pci_bus_exists);
> EXPORT_SYMBOL_GPL()?  Same for the other new exports?
>
> thanks,
>
> greg k-h
Sure, will change to EXPORT_SYMBOL_GPL in next version.
Thanks for review!
Gerry
