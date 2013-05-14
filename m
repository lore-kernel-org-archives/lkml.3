Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3ENRFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:05:20 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43200 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3ENRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:05:18 -0400
Date: Tue, 14 May 2013 13:05:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2, part 2 01/18] PCI: introduce hotplug-safe PCI bus
 iterators
Message-ID: <20130514170528.GA4030@kroah.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 12:51:45AM +0800, Jiang Liu wrote:
> +EXPORT_SYMBOL(pci_bus_exists);

EXPORT_SYMBOL_GPL()?  Same for the other new exports?

thanks,

greg k-h
