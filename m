Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaCUXkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:40:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23788 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750878AbaCUXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:40:54 -0400
Date: Fri, 21 Mar 2014 23:40:24 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 2/3] kmemleak: remove redundant code
Message-ID: <20140321234023.GA21429@arm.com>
References: <5326750E.1000004@huawei.com>
 <53267520.4030503@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53267520.4030503@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:08:00AM +0000, Li Zefan wrote:
> - remove kmemleak_padding().
> - remove kmemleak_release().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
