Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3CZV7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:59:51 -0400
Received: from 8bytes.org ([85.214.48.195]:46298 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3CZV7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:59:49 -0400
Date: Tue, 26 Mar 2013 22:59:44 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
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
Subject: Re: [PATCH v2 0/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to
 return bus number and device id
Message-ID: <20130326215944.GB30540@8bytes.org>
References: <1362009978.2808.33.camel@lorien2>
 <CAErSpo6DjjSKCFL6CjmqkOAyc1iU1TG1=n=K=AXPcU_r6ZdPGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6DjjSKCFL6CjmqkOAyc1iU1TG1=n=K=AXPcU_r6ZdPGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 22:59:47 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51521a5323678279013541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Tue, Mar 26, 2013 at 03:41:07PM -0600, Bjorn Helgaas wrote:
> Since some of these touch drivers/iommu, it'd be good if you acked
> them again, Joerg.  I know you acked them before, but there have been
> minor changes since then, so I didn't add your ack to these.  But if
> you're still OK with them, I'll refresh the branch to add it now.

Looks still good to me. You can add my

Acked-by: Joerg Roedel <joro@8bytes.org>

if you want.


	Joerg


