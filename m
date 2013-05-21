Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3EUNCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:02:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:11057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3EUNCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:02:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="244605817"
Date: Tue, 21 May 2013 15:02:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Botao Sun <botao.sun@linaro.org>
Cc: Kevin Hilman <kevin.hilman@linaro.org>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Fathi Boudra <fathi.boudra@linaro.org>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linaro-dev <linaro-dev@lists.linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: Patch merge request for STE Snowball build failure on
 linux-arm-soc-for-next.
Message-ID: <20130521130228.GD4589@zurbaran>
References: <CAMGVPmWRLddtZ3fS8DWovW=X7oQzy2x_-_SU60u+x9eTGaO9+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGVPmWRLddtZ3fS8DWovW=X7oQzy2x_-_SU60u+x9eTGaO9+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Botao,

On Tue, May 21, 2013 at 09:34:52PM +1000, Botao Sun wrote:
> Hi,
> 
> There is a build failure for STE Snowball on "linux-arm-soc-for-next"
> branch in Linaro Kernel CI system:
> 
> https://ci.linaro.org/jenkins/job/linux-arm-soc-for-next/hwpack=snowball,label=kernel_cloud/46/console
> 
> which is caused by:
> 
> 01:31:32
> /mnt/ci_build/workspace/linux-arm-soc-for-next/hwpack/snowball/label/kernel_cloud/drivers/mfd/ab8500-debugfs.c:95:23:
> fatal error: mach/irqs.h: No such file or directory
> 01:31:32  #include <mach/irqs.h>
> 01:31:32                        ^
> 01:31:32 compilation terminated.
> 01:31:32 make[3]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
> 01:31:32 make[2]: *** [drivers/mfd] Error 2
> 01:31:32 make[1]: *** [drivers] Error 2
> 
> To solve this issue, here is the patch which Linux Walleij provided on 11
> April 2013:
> 
> https://lkml.org/lkml/2013/4/11/101
> 
> Would anyone like to merge the patch to fix this compiling error?
It is queued in mfd-fixes, and I will send a pull request for that either
tonight or tomorrow.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
