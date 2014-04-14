Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaDNScW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:32:22 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:58286 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaDNScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:32:21 -0400
Message-ID: <534C29B4.5070008@gmail.com>
Date: Mon, 14 Apr 2014 14:32:20 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: catalin.marinas@arm.com, LKML <linux-kernel@vger.kernel.org>, tony@bake
Subject: Re: [PATCH 1/1] prefetch result for ARM64 atomic ops
References: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>	 <1397498661.2962.5.camel@joe-AO722>	 <CAJhHMCCPd3+AddjK2S==4jii5G5q7ioNOjJ-0ds0u6YYVeBaoQ@mail.gmail.com> <1397500153.2962.11.camel@joe-AO722>
In-Reply-To: <1397500153.2962.11.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 02:29 PM, Joe Perches wrote:
> 
> Then you should probably send this as an RFC patch.
>

Ok, I will send a new mail with fixed patch.
 

> It seems you sent the original patch again, still not compiled.
> 
> An arm64 cross-compiler is available here:
> http://linuxdriverproject.org/mediawiki/index.php/Cross-compiling_Linux_kernel_on_x86_64#Installing_arm64_cross-compiler
> 
> It'd be nice if an arm64 toolchain was on the kernel.org list too
> https://www.kernel.org/pub/tools/crosstool/
> 

I will check this out.

--
Pranith
