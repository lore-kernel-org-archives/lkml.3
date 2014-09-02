Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaIBNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:16:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58617 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaIBNQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:16:27 -0400
X-AuditID: cbfee61b-f79f86d00000144c-5a-5405c32926cd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 1
Date: Tue, 02 Sep 2014 15:16:22 +0200
Message-id: <5224004.nKGc9rK3FN@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140901230728.GM29327@sirena.org.uk>
References: <20140901230728.GM29327@sirena.org.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t9jQV3Nw6whBrf/ClhMffiEzeLyrjls
	FgcXtjE6MHtsWtXJ5vF5k1wAUxSXTUpqTmZZapG+XQJXxtSfG5gLrvBUXLp3hLGBcQJXFyMn
	h4SAicSe3k4mCFtM4sK99WwgtpDAdEaJxdvtuhi5gOwWJokXd3vBitgErCQmtq9iBLFFBJQl
	rn7fywJiMwvYSMxevYAdxBYWUJc4PHMNmM0ioCqx9Nh3sF5eAU2Jt7/mgtWLCnhK7Ni+EmwZ
	p4CxxJc7MxghFhtJ7O34xg5RLyjxY/I9qPnyEvv2T2WFsHUk9rdOY5vAKDALSdksJGWzkJQt
	YGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcns+kdzCuarA4xCjAwajEwyvxgyVEiDWx
	rLgy9xCjBAezkgivx17WECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtS
	i2CyTBycUg2M3EHCQtumqMxlFTS8tZHxFOOK7if7LPxEetibrPQezZqZOmWmef7cGYLJdpcn
	nGTbvKPzHqtBvS7/uTdB90+w25aZlnYcb1CceO9N0+IerTl+bmvCPq60DI06MHO234UlD1+s
	uZ7z4bFf7ekCnooZMsdZ/pRs6XzvIX4l7GK83YEVy3b83b1LT4mlOCPRUIu5qDgRAF/M8OlL	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, September 02, 2014 12:07:28 AM Mark Brown wrote:
> Changes since 20140829:
> 
> The akpm-current gained a conflict against Linus' tree.
> 
> Non-merge commits (relative to Linus' tree): 2553
>  2686 files changed, 98625 insertions(+), 79475 deletions(-)
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git .
> If you are tracking the linux-next tree using git, you should not use
> "git pull" to do so as that will try to merge the new linux-next release
> with the old one.  You should use "git fetch" and checkout or reset to
> the new master.
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with an
> allmodconfig for x86_64 and a multi_v7_defconfig for arm.
> 
> Below is a summary of the state of the merge.
> 
> I am currently merging 214 trees (counting Linus' and 30 trees of patches
> pending for Linus' tree).
> 
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
> 
> Status of Stephen's local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

I need following patch to make it boot on ODROID U3 board
(ARM Exynos4412 SoC based).  next-20140825 was good, next-20140828
is bad (I haven't tried next-20140826 and next-20140827).


