Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3LRLv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:51:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:5098 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab3LRLvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:51:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,507,1384300800"; 
   d="scan'208";a="85700450"
Message-ID: <1387367482.27441.123.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] allow xenfb initialization for hvm guests
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Date: Wed, 18 Dec 2013 11:51:22 +0000
In-Reply-To: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 17:53 +0000, Stefano Stabellini wrote:
> There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
> As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
> Given that no Xen toolstacks configure a xenfb backend for x86 HVM
> guests, they are not affected.

and if a toolstack did I think it would be reasonable to expect the
kernel to at least try and drive it!

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>


