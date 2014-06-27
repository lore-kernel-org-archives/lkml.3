Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaF0WOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:14:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57454 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaF0WOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:14:48 -0400
Date: Sat, 28 Jun 2014 00:14:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20140627221439.GA21418@pd.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
 <53AD0275.7020003@huawei.com>
 <20140627092227.GA23153@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com>
 <20140627211441.GA20305@nazgul.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3284C082@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3284C082@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:10:48PM +0000, Luck, Tony wrote:
> I spoke too quickly. The only MCE for which we have recovery code are
> those that hit in application code. So the processor that is trying to
> do the printk() can't possibly be holding the locks. Other processors
> might have held the lock at the time of the MCE - but they have all
> returned from the handler at the time we try the printk - so they will
> make progess and release the lock so that we can acquire it.

That could explain why we're not seeing hangs left and right. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
