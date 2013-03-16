Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3CPHY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 03:24:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58399 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3CPHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 03:24:29 -0400
Date: Sat, 16 Mar 2013 08:23:47 +0100
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com, klebers@linux.vnet.ibm.com
Subject: Re: [Patch 01/02v2] block: IBM FlashSystem 70/80 EEH Support.
Message-ID: <20130316072347.GZ31875@kernel.dk>
References: <20130315192404.GF5833@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315192404.GF5833@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> Adding in EEH support to the IBM FlashSystem 70/80 device driver.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> -------------------------------------------------------------------------------
> Changes in v2 include:
> o Fixed spelling of guarantee.
> o Fixed potential memory leak if slot reset fails out.
> o Changed list_for_each_entry_safe with list_for_each_entry.

Applied, thanks Philip.

-- 
Jens Axboe

