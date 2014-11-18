Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaKRKjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:39:39 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50512 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaKRKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:39:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] asm-generic: Add msi.h
Date: Tue, 18 Nov 2014 11:39:20 +0100
Message-ID: <1703620.E5bhVDQPHc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1411181133080.3909@nanos>
References: <alpine.DEB.2.11.1411181133080.3909@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GcsHOO78901GY/mpvZY2tuyM9jy4NmvU6CwP0YHW2dQ
 D85pxjqwonBvkNjJG0GixX/0qz6b30waL9wsyhCHu4rn8Lu5Iq
 zg1OcRM0ne6TGyXw31ubGMUoTu8QcXyXjL1uleugzSlp5xiQ49
 IVe2Vao3hcoeIO9ZDHmrq5rZ0TOPReQXnVV5NzxrS7h21PpMrr
 6dBddPdZxUT09VV8/amYKaZpKan4eULeff2YABLnQ3DoCRbSr6
 /kDheiFllc25irdpPX/OWIKvPmyBj9VwTKKKf/D9x5OHKfbbqh
 M2CXqj9nmGe66nmpxP2Z2Jmwc3/2+1xFHQhMGddC0msYFWiT7Q
 sFQe5axF9J+NnMJjZkUM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 11:34:37 Thomas Gleixner wrote:
> To support MSI irq domains we want a generic data structure for
> allocation, but we need the option to provide an architecture specific
> version of it. So instead of playing #ifdef games in linux/msi.h we
> add a generic header file and let architectures decide whether to
> include it or to provide their own implementation and provide the
> required typedef.

Acked-by: Arnd Bergmann <arnd@arndb.de>

for merging the asm-generic file

> I know that typedefs are not really nice, but in this case there are no
> forward declarations required and it's the simplest solution.

I must be missing the obvious: what problem does the typedef solve
that you would have with just a struct?

	Arnd
