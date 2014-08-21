Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaHULgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaHULf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:35:58 -0400
Message-ID: <53F5D99B.2090105@redhat.com>
Date: Thu, 21 Aug 2014 13:35:55 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 13/13] pmcraid: Use pci_enable_msix_range() instead
 of pci_enable_msix()
References: <cover.1408335523.git.agordeev@redhat.com> <0f19a7660054e85da9f2137d21d198fbe7ddd71c.1408335523.git.agordeev@redhat.com>
In-Reply-To: <0f19a7660054e85da9f2137d21d198fbe7ddd71c.1408335523.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Patch looks good.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

