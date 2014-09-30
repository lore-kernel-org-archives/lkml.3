Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaI3UyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:54:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaI3UyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:54:12 -0400
Date: Tue, 30 Sep 2014 13:54:11 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Return codes cleanup
Message-ID: <20140930205411.GA47302@vmdeb7>
References: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:40:06PM -0600, Azael Avalos wrote:
> Up for review.
> 
> This series of patches are a cleanup to the Toshiba
> configuration interface return codes (unification),
> since we are now using both the HCI and the SCI, as
> well as changing the returned type of the HCI/SCI
> read/write functions from acpi_status to u32, since
> the "status" was never checked on most of the functions.
> 
> Changes since v1:
> - Be a bit more verbose on patch 1 about the Toshiba
>   configuration interface
> - Merged patches 3 and 4 into a same patch
> 
> Azael Avalos (3):
>   toshiba_acpi: Rename hci_raw to tci_raw
>   toshiba_acpi: Unify return codes prefix from HCI/SCI to TOS
>   toshiba_acpi: Change HCI/SCI functions return code type
> 
>  drivers/platform/x86/toshiba_acpi.c | 369 ++++++++++++++++++------------------
>  1 file changed, 183 insertions(+), 186 deletions(-)

Queued to the testing branch. As we are at rc7 for 3.17 at this point, and this is a
cleanup, it is going to have to wait for the 3.18 merge window.

-- 
Darren Hart
Intel Open Source Technology Center
