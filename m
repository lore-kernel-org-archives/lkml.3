Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965923Ab3E2MTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:19:33 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1066 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965487Ab3E2MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:19:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17526
Message-ID: <51A5F24B.3000601@metafoo.de>
Date: Wed, 29 May 2013 14:19:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Dan Williams <djbw@fb.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        matt.porter@linaro.org
Subject: Re: [PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
References: <1362599767-11292-1-git-send-email-mporter@ti.com> <1362599767-11292-2-git-send-email-mporter@ti.com>
In-Reply-To: <1362599767-11292-2-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:56 PM, Matt Porter wrote:
> Add a dmaengine API to retrieve slave SG transfer limits.
> 
> The API is optionally implemented by dmaengine drivers and when
> unimplemented will return a NULL pointer. A client driver using
> this API provides the required dma channel, address width, and
> burst size of the transfer. dma_get_slave_sg_limits() returns an
> SG limits structure with the maximum number and size of SG segments
> that the given channel can handle.


Hi Matt,

Are you still working on this patchset? Or do you mind if I pick it up, make
the discussed changes and resubmit it?

Thanks,
- Lars

