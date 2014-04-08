Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaDHITj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:19:39 -0400
Received: from smtpdg96.aruba.it ([62.149.158.96]:55447 "EHLO
	smtpdg94.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbaDHITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:19:37 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 04:19:36 EDT
Message-ID: <5343AF2A.90809@seletech.com>
Date: Tue, 08 Apr 2014 10:11:22 +0200
From: alberto Villa <a.villa@seletech.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Porting 3.5 Kernel to a new ARM platform: DMA issues
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working to port 3.5 Kernel to a new platform and I'm trying to be
compliant with the new features of newer Kernel versions (I'm familiar
with 2.6). To be more specific I'm trying to adapt the port to the DMA
engine: I've got the DMA driver and the peripheral's driver which use
the DMA engine.
On older Kernel version one could write for example a dma.c under
linux/arch/arm/mach-<arch> to provide dma's specific alloc/release
functions to take care for example of a MUX between peripherals and DMA.
In release 3.5 I found the function dma_filter called during the
dma_request_channel () that seems to provide the functionality I need to
set a MUX for example during the allocation of the DMA channel, but I
can't find any customizable function called during the
dma_release_channel() to change the configuration of the MUX I set
during the dma_request_channel().
Am I missing something or in new releases this kind of operation isn't
supported?

Thank you

-- 
Dr. Villa Alberto
Sw Engineer

SeleTech srl
via Collodi, 8 20052 Monza (MI)
tel: +39 039 5962000
fax: +39 039 9716905
email: a.villa@seletech.com
web: www.seletech.com
     www.seletech.eu 

