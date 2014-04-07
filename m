Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaDGQrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:47:03 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56645 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbaDGQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:46:55 -0400
Date: Mon, 7 Apr 2014 10:46:44 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Richard Zhu <r65037@freescale.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140407164644.GB9952@obsidianresearch.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
 <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
 <235376049.yyfljDtinu@wuerfel>
 <20140325165421.GB30641@obsidianresearch.com>
 <5342D47F.4010506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342D47F.4010506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 12:38:23PM -0400, Murali Karicheri wrote:
> On 3/25/2014 12:54 PM, Jason Gunthorpe wrote:
> >On Tue, Mar 25, 2014 at 08:44:36AM +0100, Arnd Bergmann wrote:
> >
> >>I have no idea how this would work with the standard interrupt-map property,
> >>since the legacy interrupt host is now the same device as the pci host.
> >>
> >>Maybe it's better to move the legacy irqchip handling entirely out of
> >>the driver and use a separate device node for the registers so it can
> >>come with its own #interrupt-cells, and then refer to this irqchip from
> >>the interrupt-map.
> >The other DW PCI-E drivers are being fixed to use interrupt-map, so I
> >think this driver should be fixed before it goes in as well.
> 
> Could you send me a patch reference or branch that I can review to
> better understand changes required in my driver to use the bindings
> you have described below?

Bjorn is now merging it:

[PATCH v2 0/6] PCI irq mapping fixes and cleanups
http://www.spinics.net/lists/linux-pci/msg29589.html

Jason
