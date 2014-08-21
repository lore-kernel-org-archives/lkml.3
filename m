Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaHULPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbaHULPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:15:40 -0400
Message-ID: <53F5D4D7.6000600@redhat.com>
Date: Thu, 21 Aug 2014 13:15:35 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 10/13] csiostor: Use pci_enable_msix_range() instead
 of pci_enable_msix()
References: <cover.1408335523.git.agordeev@redhat.com> <3ddc5fb60e32d05996a539d7007bfb3a5e5f09b2.1408335523.git.agordeev@redhat.com>
In-Reply-To: <3ddc5fb60e32d05996a539d7007bfb3a5e5f09b2.1408335523.git.agordeev@redhat.com>
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

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

