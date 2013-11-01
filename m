Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3KABFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 21:05:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:17457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3KABFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 21:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="427999990"
Message-ID: <5272FDE7.4060000@linux.intel.com>
Date: Thu, 31 Oct 2013 18:03:35 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] checkpatch: Improve "return is not a function" test
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>  <1383070766.12439.13.camel@joe-AO722> <526FFED4.4070902@linux.intel.com>  <1383071755.12439.17.camel@joe-AO722> <52700D4C.10008@linux.intel.com>  <1383075490.12439.26.camel@joe-AO722> <1383261164.2769.6.camel@joe-AO722>
In-Reply-To: <1383261164.2769.6.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 04:12 PM, Joe Perches wrote:
> Find a few more cases where parentheses are used around
> the value of a return statement.
> 
> This now uses the "$balanced_parens" test and also makes
> the test depend on perl v5.10 and higher.
> 
> This now finds return with parenthesis uses the old code
> did not find like:
> 
> ERROR: return is not a function, parentheses are not required
> #211: FILE: arch/m68k/include/asm/sun3xflop.h:211:
> +		return ((error == 0) ? 0 : -1);
> 
> Signed-off-by: Joe Perches <joe@perches.com>

It catches the previous false-negative I had.

Acked-by: David Cohen <david.a.cohen@linux.intel.com>
