Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3B0Vsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:48:30 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32120 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3B0Vs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:48:28 -0500
Message-ID: <1362001700.2808.9.camel@lorien2>
Subject: Re: [PATCH 1/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
From: Shuah Khan <shuah@fc.hp.com>
Reply-To: shuah@fc.hp.com
To: Bjorn Helgaas <bhelgaas@google.com>, joro@8bytes.org
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, linasvepstas@gmail.com,
        davej@redhat.com, tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, shemminger@vyatta.com, jiang.liu@huawei.com,
        wangyijing@huawei.com, shuahkhan@gmail.com
Date: Wed, 27 Feb 2013 14:48:20 -0700
In-Reply-To: <1361829202.2958.3.camel@lorien2>
References: <1360623637.2950.63.camel@lorien2>
	 <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com>
	 <1361810245.2975.14.camel@lorien2>
	 <CAErSpo7u+vos73jTR1ASzv3XRwcMX1XwptP41mUWekz7Tv249w@mail.gmail.com>
	 <1361829202.2958.3.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 14:53 -0700, Shuah Khan wrote:
> On Mon, 2013-02-25 at 14:23 -0700, Bjorn Helgaas wrote:
> > On Mon, Feb 25, 2013 at 9:37 AM, Shuah Khan <shuah.khan@hp.com> wrote:
> > > On Wed, 2013-02-20 at 18:19 -0700, Bjorn Helgaas wrote:
> > >> On Mon, Feb 11, 2013 at 4:00 PM, Shuah Khan <shuah.khan@hp.com> wrote:

> > 
> > It's not nice and consistent, but it does follow the simple rule of
> > "don't expose things to user-space unnecessarily."  We might want to
> > add a comment to keep somebody from cleaning it up later.
> 
> ok. Will resend patches adding the new defines to linux/pci.h and
> renaming PCI_BUS() to PCI_BUS_NR() or PCI_BUS_NUM() like you suggested.
> 
> Thanks,
> -- Shuah
> 

Bjorn/Joerg,

I added PCI_BUS_NUM() amd PCI_DEVID() to linux/pci.h. Please note that
changing PCI_BUS() to PCI_BUS_NUM() required additional changes to AMD
IOMMU source files and aer driver. Essentially in addition to removing
local PCI_BUS() define, PCI_BUS() usages are changed to PCI_BUS_NUM(). I
am resending the patches.

Thanks,
-- Shuah


