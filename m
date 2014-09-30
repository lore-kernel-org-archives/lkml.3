Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaI3PmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:42:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52716 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaI3PmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:42:08 -0400
Date: Tue, 30 Sep 2014 16:42:02 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Message-ID: <20140930154201.GR841@e106497-lin.cambridge.arm.com>
References: <706416181.hbVGLDA3o6@wuerfel>
 <20140930144506.GQ841@e106497-lin.cambridge.arm.com>
 <2033939.5UfzeSiRKs@wuerfel>
MIME-Version: 1.0
In-Reply-To: <2033939.5UfzeSiRKs@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 30 Sep 2014 15:42:02.0780 (UTC) FILETIME=[148285C0:01CFDCC5]
X-MC-Unique: 114093016420503301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 04:15:19PM +0100, Arnd Bergmann wrote:
> On Tuesday 30 September 2014 15:45:06 Liviu Dudau wrote:
> > 
> > Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > 
> > Is that triggered by shmobile_defconfig?
> > 
> > 
> 
> No, I only found it using randconfig testing, shmobile enables CONFIG_OF by
> default.

Hmm, I was looking at who defines CONFIG_PCI_RCAR_GEN2_PCIE and it's only
present in shmobile_defconfig, but that one does not select any OF options (other
than CONFIG_ARM_APPENDED_DTB). So there is no way of triggering this other
than by randconfig?

Best regards,
Liviu

> 
> 	Arnd
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

