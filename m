Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaJTPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:19:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49517 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaJTPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:19:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,756,1406592000"; 
   d="scan'208";a="184194510"
Message-ID: <1413818345.29506.4.camel@citrix.com>
Subject: Re: [PATCH v4 5/7] xen/arm/arm64: merge xen/mm32.c into xen/mm.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Mon, 20 Oct 2014 16:19:05 +0100
In-Reply-To: <1412941908-5850-5-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
	 <1412941908-5850-5-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 12:51 +0100, Stefano Stabellini wrote:
> Merge xen/mm32.c into xen/mm.c.
> As a consequence the code gets compiled on arm64 too: introduce a few
> compat functions to actually be able to compile it.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


