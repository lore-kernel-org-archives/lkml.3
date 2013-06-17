Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3FQXvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:51:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:37807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab3FQXvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:51:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="331171826"
Date: Tue, 18 Jun 2013 01:51:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 1/2] mfd: ssbi: Add MODULE_DEVICE_TABLE
Message-ID: <20130617235100.GA7998@zurbaran>
References: <1370288384-3122-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370288384-3122-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jun 03, 2013 at 12:39:43PM -0700, Stephen Boyd wrote:
> This allows the ssbi module to be autoloaded on boot.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> No changes since v1
> 
>  drivers/mfd/ssbi.c | 1 +
>  1 file changed, 1 insertion(+)
Both patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
