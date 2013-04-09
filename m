Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937648Ab3DIK2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:28:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:36244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935614Ab3DIK2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="224976759"
Date: Tue, 9 Apr 2013 12:28:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] mfd: support stmpe1801 18 bits enhanced port expander
Message-ID: <20130409102841.GV24058@zurbaran>
References: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365496521-16880-1-git-send-email-jean-nicolas.graux@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Nicolas,

On Tue, Apr 09, 2013 at 10:35:19AM +0200, Jean-Nicolas Graux wrote:
> Provides support for 1801 variant of stmpe gpio port expanders.
> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> special key or dedicated key function.
> 
> Note that special/dedicated key function is not supported yet.
> 
> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> ---
>  drivers/mfd/Kconfig       |    1 +
>  drivers/mfd/stmpe-i2c.c   |    1 +
>  drivers/mfd/stmpe.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/mfd/stmpe.h       |   49 +++++++++++++++++++++++
>  include/linux/mfd/stmpe.h |    3 ++
>  5 files changed, 150 insertions(+), 1 deletion(-)
Patch applied now, unless Lee or Linus object to it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
