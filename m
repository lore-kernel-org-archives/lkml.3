Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3CZWXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:23:55 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:40121 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3CZWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:23:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130326215944.GB30540@8bytes.org>
References: <1362009978.2808.33.camel@lorien2> <CAErSpo6DjjSKCFL6CjmqkOAyc1iU1TG1=n=K=AXPcU_r6ZdPGA@mail.gmail.com>
 <20130326215944.GB30540@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 26 Mar 2013 16:23:32 -0600
Message-ID: <CAErSpo6QWxya9PBKngvfgjjZZ2bA=BtMHRBsCpj8rMMC5itiRQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
To: Joerg Roedel <joro@8bytes.org>
Cc: shuah.khan@hp.com, Jiang Liu <jiang.liu@huawei.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linas Vepstas <linasvepstas@gmail.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        iommu@lists.linux-foundation.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 3:59 PM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Bjorn,
>
> On Tue, Mar 26, 2013 at 03:41:07PM -0600, Bjorn Helgaas wrote:
>> Since some of these touch drivers/iommu, it'd be good if you acked
>> them again, Joerg.  I know you acked them before, but there have been
>> minor changes since then, so I didn't add your ack to these.  But if
>> you're still OK with them, I'll refresh the branch to add it now.
>
> Looks still good to me. You can add my
>
> Acked-by: Joerg Roedel <joro@8bytes.org>
>
> if you want.

Added and branch updated, thanks!
