Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3FEHTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:19:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51651 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3FEHTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:19:10 -0400
Date: Wed, 5 Jun 2013 00:19:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] workqueue: move the internal helper from .h to .c
Message-ID: <20130605071906.GB7303@mtj.dyndns.org>
References: <51AEE452.8080605@linux.vnet.ibm.com>
 <51AEE473.6020402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEE473.6020402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:10:43PM +0800, Michael Wang wrote:
> alloc_workqueue_attrs(), free_workqueue_attrs() and apply_workqueue_attrs()
> are only used internally, move them to .c and make them static.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Nack.  That's the published and only interface to use custom attrs
from inside kernel.

Thanks.

-- 
tejun
