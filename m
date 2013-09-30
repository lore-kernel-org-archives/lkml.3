Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3I3JE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:04:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50094 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752041Ab3I3JEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:04:55 -0400
Date: Mon, 30 Sep 2013 10:04:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        =?iso-8859-1?Q?Andersson=2C_Bj=F6rn?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: Re: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Message-ID: <20130930090410.GB17042@arm.com>
References: <5245ECC3.8070200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245ECC3.8070200@gmail.com>
Thread-Topic: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:38:27PM +0100, Frank Rowand wrote:
> From: Roman Bobniev <roman.bobniev@sonymobile.com>
> 
> When kmemleak checking is enabled and CONFIG_SLUB_DEBUG is
> disabled, the kmemleak code for small block allocation is
> disabled.  This results in false kmemleak errors when memory
> is freed.
> 
> Move the kmemleak code for small block allocation out from
> under CONFIG_SLUB_DEBUG.
> 
> Signed-off-by: Roman Bobniev <roman.bobniev@sonymobile.com>
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
