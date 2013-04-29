Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab3D2UGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:06:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3D2UG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:06:29 -0400
Message-ID: <517ED2A6.5030200@infradead.org>
Date: Mon, 29 Apr 2013 13:05:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Subject: Re: linux-next: Tree for Apr 29
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 


(who is responsible for MEM_SOFT_DIRTY?)


on x86_64:

warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR which has unmet direct dependencies (PROC_FS && MMU)

because MEM_SOFT_DIRTY selects PROC_PAGE_MONITOR when CONFIG_PROC_FS is not enabled.


Can MEM_SOFT_DIRTY depend on PROC_FS?

and the help text for MEM_SOFT_DIRTY refers to Documentation/vm/soft-dirty.txt,
which does not exist.  Please add the file.


-- 
~Randy
