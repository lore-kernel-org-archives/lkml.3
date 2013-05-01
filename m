Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3EATfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:35:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37271
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808Ab3EATfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:35:18 -0400
Date: Wed, 1 May 2013 21:35:01 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 8/9] rsxx: Fixes CPU usage issues on RHEL 6 Kernels.
Message-ID: <20130501193501.GL7800@kernel.dk>
References: <20130430200049.GA15930@oc6784271780.ibm.com>
 <20130501114420.GX7800@kernel.dk>
 <20130501143449.GB17546@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501143449.GB17546@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01 2013, Philip J. Kelleher wrote:
> Again, thanks for the prompt reply.
> 
> Also, sorry for my poor explaination skills :)
> 
> The RHEL 6.x version of the driver is using the legacy
> worqueue create function, 'create_singlethread_workqueue'.
> This would cause heavy usage of one CPU if data was being
> thrashed pretty hard. So, in order to fix it, workqueues
> are now being created with 'create_workqueue' and
> synchronization with mutexes.

See, that is what should have been in the changelog!

-- 
Jens Axboe

