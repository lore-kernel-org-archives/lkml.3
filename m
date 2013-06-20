Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610Ab3FTROb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:14:31 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34444 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198Ab3FTRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:14:29 -0400
Message-ID: <51C3386F.5050009@gmail.com>
Date: Fri, 21 Jun 2013 01:14:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 3/3] PCI: mark pci_scan_bus_parented() as __deprecated
References: <1371747665-12768-1-git-send-email-liuj97@gmail.com> <1371747665-12768-4-git-send-email-liuj97@gmail.com> <20130620170855.GA21465@kroah.com>
In-Reply-To: <20130620170855.GA21465@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 01:08 AM, Greg Kroah-Hartman wrote:
> On Fri, Jun 21, 2013 at 01:01:05AM +0800, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
>> comments.
> 
> Why not just delete the function, if no in-kernel users are calling it,
> it's no longer needed at all.
Hi Greg,
I thought that may break out of tree drivers, so give a warning first
for smooth transitions. Any guidelines here? I have some other similar
cases to keep some exported symbols just for out of tree drivers.
Regards!
Gerry

> 
> thanks,
> 
> greg k-h
> 

