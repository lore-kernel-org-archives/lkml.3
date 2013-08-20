Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3HTBm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:42:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:1820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3HTBmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,916,1367996400"; 
   d="scan'208";a="389850609"
Date: Tue, 20 Aug 2013 03:42:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH] mfd: dbx500-prcmu: Move PRCMU numerical clock
 identifiers into DT include file
Message-ID: <20130820014251.GG13324@zurbaran>
References: <1376912287-26460-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376912287-26460-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Aug 19, 2013 at 12:38:07PM +0100, Lee Jones wrote:
> These are required to request DBx500 PRCMU clocks from Device Tree. The
> numbers used are taken directly from the Hardware Specification document.
> We're moving them from the DBx500 PRCMU include file into the DT include
> directory and referencing them from the former via a #include.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Since I expect you want to carry that through your tree:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
