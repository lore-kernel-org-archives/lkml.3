Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937381Ab3DIKFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:05:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:55005 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934845Ab3DIKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="283585062"
Date: Tue, 9 Apr 2013 12:05:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] mfd: db8500-prcmu: Return early if the TCPM cannot
 be located
Message-ID: <20130409100510.GP24058@zurbaran>
References: <1365071941-23475-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365071941-23475-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, Apr 04, 2013 at 11:39:00AM +0100, Lee Jones wrote:
> Currently we check to see if we obtained the Tightly Coupled Program
> Memory (TCPM) base and only execute the code within the check if we
> have it. It's more traditional to return early if we don't have it.
> This way we can flatten most of the function's code down to a single
> tab spacing.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |   40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
I had to apply this one manually, please check if it was done correctly from
my mfd-next tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
