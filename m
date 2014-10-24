Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaJXJ2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:28:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21748 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaJXJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:28:08 -0400
X-IronPort-AV: E=Sophos;i="5.04,779,1406592000"; 
   d="scan'208";a="185832433"
Message-ID: <1414142885.15687.25.camel@citrix.com>
Subject: Re: [PATCH v5 4/6] xen/arm/arm64: merge xen/mm32.c into xen/mm.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>
Date: Fri, 24 Oct 2014 10:28:05 +0100
In-Reply-To: <1414085246-16160-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
	 <1414085246-16160-4-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 18:27 +0100, Stefano Stabellini wrote:
> Merge xen/mm32.c into xen/mm.c.
> As a consequence the code gets compiled on arm64 too: introduce a few
> compat functions to actually be able to compile it.
> Introduce xen_is_dma_coherent on arm64 and call into the dma_ops
> functions from the xen_dma wrappers in page-coherent.h to handle
> non-coherent devices.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


