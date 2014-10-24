Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbaJXJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:23:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32220 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaJXJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:23:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,779,1406592000"; 
   d="scan'208";a="185831763"
Message-ID: <1414142592.15687.22.camel@citrix.com>
Subject: Re: [PATCH v5 2/6] xen/arm: remove outer_*_range call
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>
Date: Fri, 24 Oct 2014 10:23:12 +0100
In-Reply-To: <1414085246-16160-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
	 <1414085246-16160-2-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 18:27 +0100, Stefano Stabellini wrote:
> Dom0 is not actually capable of issuing outer_inv_range or
> outer_clean_range calls.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


