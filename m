Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaJTPSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:18:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32886 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaJTPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:18:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,756,1406592000"; 
   d="scan'208";a="184194245"
Message-ID: <1413818311.29506.3.camel@citrix.com>
Subject: Re: [PATCH v4 4/7] xen/arm: use is_dma_coherent
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Mon, 20 Oct 2014 16:18:31 +0100
In-Reply-To: <1412941908-5850-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
	 <1412941908-5850-4-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 12:51 +0100, Stefano Stabellini wrote:
> Use is_dma_coherent to check whether we need to issue cache maintenance
> operations rather than checking on the existence of a particular
> dma_ops function for the device.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


