Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3HECss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:48:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:22123 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3HECsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:48:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,815,1367996400"; 
   d="scan'208";a="277659536"
Message-ID: <51FF123C.8010208@intel.com>
Date: Mon, 05 Aug 2013 10:47:24 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: Ilari Stenroth <ilari.stenroth@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
References: <kt91u2$jhs$1@ger.gmane.org> <20130730193530.GB23299@pd.tnic> <kt951r$m5m$1@ger.gmane.org> <20130730195402.GD23299@pd.tnic> <51FA220B.5070307@intel.com> <51FA256C.80001@intel.com>
In-Reply-To: <51FA256C.80001@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:07 PM, Alex Shi wrote:
> From 6fb21a9ce475cfc6c7c39bdfd3d9422be24cdb74 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Wed, 31 Jul 2013 16:28:42 +0800
> Subject: [PATCH 1/2] x86/tlb_flushall_shift: add Ivybridge EP CPU support
> 
> Tested with munmap.c on Ivybridge EP 2S machine, the best shift value is
> 2, that means when the tlb flush entries less than 64, single invlpg has
> performance benefit on this machine.
> The testcase come from: https://lkml.org/lkml/2012/5/17/59
> Results show it has about 5% to 30% performance increase.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---

Any comments are appreciated!

-- 
Thanks
    Alex
