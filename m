Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688Ab3EALol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:44:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35350
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab3EALoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:44:34 -0400
Date: Wed, 1 May 2013 13:44:20 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 8/9] rsxx: Fixes CPU usage issues on RHEL 6 Kernels.
Message-ID: <20130501114420.GX7800@kernel.dk>
References: <20130430200049.GA15930@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430200049.GA15930@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This changes how the driver schedules the work to the
> workqueue threads. 
> 
> Note: This patch is primarily for the Red Hat 6 Kernels.

You need to properly explain the problem and how it's fixed in the
changelog. The above really makes the read none the wiser on what the
issue is.

-- 
Jens Axboe

