Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3BCRA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:00:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:51434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3BCRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:00:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="257057517"
Date: Sun, 3 Feb 2013 18:00:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 07/10] mfd: wm5102: Add registers for microphone
 detection level configuration
Message-ID: <20130203170053.GH8476@sortiz-mobl>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359259652-8565-7-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359259652-8565-7-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jan 27, 2013 at 12:07:29PM +0800, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
This one has build dependencies on the previous one, so I'll either let you
carry it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
