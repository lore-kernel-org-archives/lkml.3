Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3DZON2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:13:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:48396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3DZON1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:13:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,559,1363158000"; 
   d="scan'208";a="233092263"
Date: Fri, 26 Apr 2013 16:13:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mfd: vexpress: Handle pending config transactions
Message-ID: <20130426141323.GA4796@zurbaran>
References: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
 <1366910091-17971-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910091-17971-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Thu, Apr 25, 2013 at 06:14:51PM +0100, Pawel Moll wrote:
> The config transactions "scheduler" was hopelessly broken,
> repeating completed transaction instead of picking up
> next pending one.
> 
> Fixed now. Also improved debug messages.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/mfd/vexpress-config.c |   35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
Applied and pushed, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
