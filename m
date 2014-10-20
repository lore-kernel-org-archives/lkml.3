Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaJTPOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:14:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13711 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaJTPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:14:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,756,1406592000"; 
   d="scan'208";a="184191931"
Message-ID: <1413818048.13796.28.camel@citrix.com>
Subject: Re: [PATCH v4 1/7] xen/arm: remove handling of
 XENFEAT_grant_map_identity
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Mon, 20 Oct 2014 16:14:08 +0100
In-Reply-To: <1412941908-5850-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
	 <1412941908-5850-1-git-send-email-stefano.stabellini@eu.citrix.com>
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
> The feature has been removed from Xen. Also Linux cannot use it on ARM32
> without CONFIG_ARM_LPAE.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


