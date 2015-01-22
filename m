Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbbAVJqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:46:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:33809 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbbAVJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:46:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,448,1418112000"; 
   d="scan'208";a="674013437"
Date: Thu, 22 Jan 2015 11:46:03 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] gpio: sch: Consolidate similar algorithms
Message-ID: <20150122094603.GW1850@lahna.fi.intel.com>
References: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 06:32:21PM +0800, Chang Rebecca Swee Fun wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>

Like Alexandre said, you can carry the Reviewed-by: tags with the patch
if you only fixed build warning.

In future please make sure that patches compile without warnings and
that they have proper testing done beforehand. Thanks.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
