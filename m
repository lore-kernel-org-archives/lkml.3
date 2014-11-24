Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaKXLDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:03:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:60168 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaKXLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:03:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,448,1413244800"; 
   d="scan'208";a="196013134"
Date: Mon, 24 Nov 2014 11:03:08 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] xen-netback: do not report success if
 backend_create_xenvif() fails
Message-ID: <20141124110308.GA322@zion.uk.xensource.com>
References: <20141124100053.GC30053@zion.uk.xensource.com>
 <1416826680-19145-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416826680-19145-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:58:00PM +0300, Alexey Khoroshilov wrote:
> If xenvif_alloc() or xenbus_scanf() fail in backend_create_xenvif(),
> xenbus is left in offline mode but netback_probe() reports success.
> 
> The patch implements propagation of error code for backend_create_xenvif().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Wei Liu <wei.liu2@citrix.com>

Thanks!
