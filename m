Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaHTRS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:18:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27923 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaHTRSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:18:55 -0400
X-IronPort-AV: E=Sophos;i="5.01,903,1400025600"; 
   d="scan'208";a="163475039"
Message-ID: <1408555132.16955.5.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen-pciback: Add MODULE_ALIAS for pciback.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 20 Aug 2014 18:18:52 +0100
In-Reply-To: <1408552838-4032-2-git-send-email-konrad.wilk@oracle.com>
References: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
	 <1408552838-4032-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 12:40 -0400, Konrad Rzeszutek Wilk wrote:
> The rest of the Xen device drivers use an module alias
> to load devices when they shop up in XenBus.

"show".
>  
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_ALIAS("xen-backend:pci");
> +MODULE_ALIAS("xen:pci");

Isn't that xen-backend:pci already the right thing for a backend device?
xen: is for frontends, I thought.

Ian.

