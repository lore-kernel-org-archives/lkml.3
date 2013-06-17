Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3FQWI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:08:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:26881 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3FQWI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="318479667"
Date: Tue, 18 Jun 2013 00:08:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Reset device during probe
Message-ID: <20130617220823.GR7998@zurbaran>
References: <1368793521-30092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368793521-30092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, May 17, 2013 at 01:25:21PM +0100, Mark Brown wrote:
> Ensure that the device is in a known good state. This should have little
> practical impact as the runtime PM will reset the device shortly after
> probe but it's neater.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
