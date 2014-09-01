Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaIANvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:51:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:57249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaIANvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:51:31 -0400
Date: Mon, 1 Sep 2014 15:51:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20140901135129.GN27892@worktop.ger.corp.intel.com>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409006611-30741-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:43:29PM -0700, Andi Kleen wrote:

> +	case 61: /* Broadwell Client */

Again, no other description has "Client" in.
