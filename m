Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbaE3QKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:10:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:47428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbaE3QKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548988680"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140530052502.12443.qmail@ns.horizon.com>
References: <20140530052502.12443.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 May 2014 09:10:48 -0700
Message-ID: <1401466248.2970.462.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 01:25 -0400, George Spelvin wrote:

> 
> Averaging the 8K bytes per update, I do see an average of 3.2 cycles per
> operation (that is, per 8K of data processed) lost, or about 1 cycle per
> (3K or less) block processed.  I'm hoping the reduced D-cache polution
> makes it up somewhere else.

That's very small (less than 0.2%) so I think it's acceptable.

Tim


