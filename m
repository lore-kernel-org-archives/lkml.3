Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3HESNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:13:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:23729 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HESNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:13:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,820,1367971200"; 
   d="scan'208";a="7476645"
Message-ID: <1375726381.10660.219.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/3] MAINTAINERS: Update the Xen subsystem's
 with proper mailing list.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 5 Aug 2013 19:13:01 +0100
In-Reply-To: <1375725937-22930-3-git-send-email-konrad.wilk@oracle.com>
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com>
	 <1375725937-22930-3-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 14:05 -0400, Konrad Rzeszutek Wilk wrote:
> And also drop the virtualization one since we don't really use it.
> 
> CC: stefano.stabellini@eu.citrix.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

The whole thing but especially:

>  XEN NETWORK BACKEND DRIVER
>  M:	Ian Campbell <ian.campbell@citrix.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/xen-netback/*

Ian.

