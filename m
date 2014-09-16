Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaIPO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:56:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56626 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIPO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:56:12 -0400
Message-ID: <54184F88.60001@martingkelly.com>
Date: Tue, 16 Sep 2014 07:56:08 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org, vishwesh.m.rudramuni@intel.com, joe@perches.com,
        hpa@linux.intel.com, aubrey.li@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410841463-24826-1-git-send-email-martin@martingkelly.com> <20140916063850.GB14807@gmail.com>
In-Reply-To: <20140916063850.GB14807@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:38 PM, Ingo Molnar wrote:
> 
> This uglifies the code which is bad. A nicer fix would be to 
> improve the code: for example define pmc_dbgfs_register() in the 
> !DEBUG_FS case as well, with a return 0 or so.
> 
> Thanks,
> 
> 	Ingo
> 

I like your suggestion and will issue a revision.
