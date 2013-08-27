Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3H0SJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:09:27 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:32882 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3H0SJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:09:25 -0400
Date: Tue, 27 Aug 2013 14:09:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the libata tree
Message-ID: <20130827180917.GA12212@mtj.dyndns.org>
References: <20130827125049.62d12bba371fe8d9df85a227@canb.auug.org.au>
 <521C3E89.3090905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C3E89.3090905@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:52:09PM +0800, Aaron Lu wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> Subject: [PATCH] ata: acpi: Remove ata_dev_acpi_handle stub in libata.h
> 
> The ata_dev_acpi_handle is defined in libata-acpi.c and the only
> external user is libata-zpodd.c, which is built when CONFIG_ATA_ACPI
> is set, so there is no need to make an empty stub function for
> !CONFIG_ATA_ACPI case in libata.h. It also causes compile errors due to
> acpi_handle is not defined when !CONFIG_ACPI. This patch fixes this
> problem by removing the empty stub.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Yeap, tested and works.  Applied to libata/for-3.12.  Thanks.

Stephen, sorry about the trouble.

-- 
tejun
