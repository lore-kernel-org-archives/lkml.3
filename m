Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3FGUhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:37:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39334 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FGUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <51B1FC83.7090402@gmail.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
 <1369489718-25869-5-git-send-email-jiang.liu@huawei.com> <CAErSpo5bysp-s-twUWgZEyJD01skjW=vXkcQBYkn_TALP83r1g@mail.gmail.com>
 <51B0B99C.4020009@gmail.com> <20130607143758.GA13427@phenom.dumpdata.com> <51B1FC83.7090402@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Jun 2013 14:37:15 -0600
Message-ID: <CAErSpo4nTW1U2HVv4fM2snF4yPPOwdCE+6eiDnTEpQ+51514pQ@mail.gmail.com>
Subject: Re: [PATCH v3, part1 04/10] PCI: mark pci_scan_bus_parented() as __deprecated
To: Jiang Liu <liuj97@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 9:30 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 06/07/2013 10:37 PM, Konrad Rzeszutek Wilk wrote:
>> On Fri, Jun 07, 2013 at 12:32:28AM +0800, Jiang Liu wrote:
>>> On Thu 06 Jun 2013 04:04:36 AM CST, Bjorn Helgaas wrote:
>>>> [+cc Konrad, Jeremy, xen-devel (users of interface you're deprecating)]
>>>>
>>>> On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>>>> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
>>>>> comments.

I dropped this patch (marking pci_scan_bus_parented() as __deprecated)
from the series for now.  When the xen-pcifront stuff gets resolved,
we can deprecate the interface at the same time.

Bjorn
