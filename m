Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaHKMRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:17:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44445 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHKMRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:17:39 -0400
X-IronPort-AV: E=Sophos;i="5.01,841,1400025600"; 
   d="scan'208";a="160548869"
Date: Mon, 11 Aug 2014 13:17:37 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next v2] xen-netback: Don't deschedule NAPI when
 carrier off
Message-ID: <20140811121737.GC3249@zion.uk.xensource.com>
References: <1407758504-8150-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407758504-8150-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:01:44PM +0100, Zoltan Kiss wrote:
> In the patch called "xen-netback: Turn off the carrier if the guest is not able
> to receive" NAPI was descheduled when the carrier was set off. That's
> not what most of the drivers do, and we don't have any specific reason to do so
> as well, so revert that change.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org

Acked-by: Wei Liu <wei.liu2@citrix.com>
