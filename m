Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaGVQJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:09:20 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:44691 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaGVQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+mB=1JupzQy+R14kKAk7mTJR2FcZ+cQv-uXQSB6jEVBW95aGQ@mail.gmail.com>
References: <1404361654-2894-1-git-send-email-sthokal@xilinx.com>
 <20140716173824.GA24357@google.com> <CA+mB=1JupzQy+R14kKAk7mTJR2FcZ+cQv-uXQSB6jEVBW95aGQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 22 Jul 2014 10:08:54 -0600
Message-ID: <CAErSpo41HwMferWm8q69Sz0t-Cs1WHgwwVp1VKsoxxyvrgQhfQ@mail.gmail.com>
Subject: Re: [PATCH v4] pcie: Add Xilinx PCIe Host Bridge IP driver
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:10 PM, Srikanth Thokala <sthokal@xilinx.com> wrote:
> On Wed, Jul 16, 2014 at 11:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> ...
>> I see I forgot to ask for a MAINTAINERS entry for this driver.  Can
>> you add one?
>
> There was a discussion on this earlier and Michal mentioned it is not
> required as it is
> handled by our Xilinx record.
>
> Here is the reply from Michal to the MAINTAINERS update comment,
>
> < Reply from Michal >
>
>> Please also include a MAINTAINERS update for drivers/pci/host/pci-xilinx.c.
>
> This should be handle by our record that's why MAINTAINERS update is
> not necessary.
> (N: xilinx below)

That's technically true in the sense that get_maintainer.pl will do
the right thing, but I often review patches in email (without
extracting them), so it's more convenient to just look in MAINTAINERS
to see if they have the right acks.  But I guess I can deal with it
either way.

> ARM/ZYNQ ARCHITECTURE
> M:      Michal Simek <michal.simek@xilinx.com>
> L:      linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> W:      http://wiki.xilinx.com
> T:      git git://git.xilinx.com/linux-xlnx.git
> S:      Supported
> F:      arch/arm/mach-zynq/
> F:      drivers/cpuidle/cpuidle-zynq.c
> N:      zynq
> N:      xilinx
