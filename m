Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaCUXob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:44:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:26126 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803AbaCUXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:44:27 -0400
Date: Fri, 21 Mar 2014 23:44:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 3/3] kmemleak: change some global variables to int
Message-ID: <20140321234407.GB21429@arm.com>
References: <5326750E.1000004@huawei.com>
 <53267560.5060803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53267560.5060803@huawei.com>
Thread-Topic: [PATCH v2 3/3] kmemleak: change some global variables to int
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:09:04AM +0000, Li Zefan wrote:
> They don't have to be atomic_t, because they are simple boolean
> toggles.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

A reason for which I had atomic_t was to avoid compiler optimisations
but I don't immediately see how it could go wrong. Assuming that you
have tested it,

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
