Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaJINU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:20:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:50133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaJINUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:20:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,684,1406617200"; 
   d="scan'208";a="602811650"
Date: Thu, 9 Oct 2014 16:20:42 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ray Jui <rjui@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Loic Poulain <loic.poulain@intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, JD Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: Re: [PATCH] serial: 8250_dw: Add DMA support for non-ACPI platforms
Message-ID: <20141009132042.GC9108@kuha.fi.intel.com>
References: <rjui@broadcom.com>
 <1412728547-4126-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412728547-4126-1-git-send-email-rjui@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:35:47PM -0700, Ray Jui wrote:
> The dma pointer under struct uart_8250_port is currently left
> unassigned for non-ACPI platforms. It should be pointing to the dma
> member in struct dw8250_data like how it was done for ACPI, so the core
> 8250 code will try to request for DMA when registering the port
> 
> If DMA is not enabled in device tree, request DMA will fail and the
> driver will fall back to PIO
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
> Tested-by: Scott Branden <sbranden@broadcom.com>

OK by me. FWIW..

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>


-- 
heikki
