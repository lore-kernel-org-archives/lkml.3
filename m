Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3COGqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:46:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:3811 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab3COGp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="303293272"
Date: Fri, 15 Mar 2013 07:45:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] mfd: ab8500: kill "reg" property from binding
Message-ID: <20130315064520.GE12559@zurbaran>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363298204-8014-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Mar 14, 2013 at 10:56:40PM +0100, Arnd Bergmann wrote:
> The ab8500 device is a child of the prcmu device, which is a memory mapped
> bus device, whose children are addressable using physical memory addresses,
> not using mailboxes, so a mailbox number in the ab8500 node cannot be
> parsed by DT. Nothing uses this number, since it was only introduced
> as part of the failed attempt to clean up prcmu mailbox handling, and
> we can simply remove it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Please apply to MFD tree for 3.9
Already applied to mfd-fixes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
