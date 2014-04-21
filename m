Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaDUPWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:22:18 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:33758 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbaDUPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:22:14 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 11:22:14 EDT
From: "Steve Wise" <swise@opengridcomputing.com>
To: "'Christoph Jaeger'" <christophjaeger@linux.com>, <swise@chelsio.com>,
        <roland@kernel.org>, <sean.hefty@intel.com>,
        <hal.rosenstock@gmail.com>
Cc: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1398092562-11116-1-git-send-email-christophjaeger@linux.com>
In-Reply-To: <1398092562-11116-1-git-send-email-christophjaeger@linux.com>
Subject: RE: [PATCH] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
Date: Mon, 21 Apr 2014 10:16:20 -0500
Message-ID: <002701cf5d74$a6202df0$f26089d0$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLADJw9qsdx86xOqkNbGQajoWT7x5k6z+PA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Christoph Jaeger [mailto:christophjaeger@linux.com]
> Sent: Monday, April 21, 2014 10:03 AM
> To: swise@chelsio.com; roland@kernel.org; sean.hefty@intel.com; hal.rosenstock@gmail.com
> Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; Christoph Jaeger
> Subject: [PATCH] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
> 
> c4iw_alloc() bails out without freeing the storage that 'devp' points to.
> 
> Picked up by Coverity - CID 1204241.
> 
> Fixes: fa658a98a2 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Acked-by: Steve Wise <swise@opengridcomputing.com>

thanks!



