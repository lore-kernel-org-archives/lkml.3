Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936886Ab3DJVbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:31:07 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59142 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761615Ab3DJVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:31:04 -0400
Date: Wed, 10 Apr 2013 23:30:59 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>, Andrew Murray <Andrew.Murray@arm.com>,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, jgunthorpe@obsidianresearch.com,
        kgene.kim@samsung.com, paulus@samba.org, bhelgaas@google.com,
        suren.reddy@samsung.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/3] of/pci: Unify pci_process_bridge_OF_ranges from
 Microblaze and PowerPC
Message-ID: <20130410233059.5cdcc119@skate>
In-Reply-To: <51656592.7070806@gmail.com>
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com>
	<1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
	<51656592.7070806@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, Michal,

On Wed, 10 Apr 2013 08:13:54 -0500, Rob Herring wrote:
> Adding Ben H and Michal...
> 
> On 04/10/2013 02:29 AM, Andrew Murray wrote:
> > The pci_process_bridge_OF_ranges function, used to parse the
> > "ranges" property of a PCI host device, is found in both Microblaze
> > and PowerPC architectures. These implementations are nearly
> > identical. This patch moves this common code to a common place.
> > 
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> One comment below. Otherwise,
> 
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>
> 
> You need also need acks from Ben and Michal.

Ben, Michal, could you review/test this patch from Andrew Murray? I
need it as a dependency of "[PATCH v5 2/3] of/pci: Provide support for
parsing PCI DT ranges property", which itself is used by the Marvell
PCIe driver I'm hoping to get merged in 3.10.

Thanks a lot for your feedback,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
