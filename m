Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3COFOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:14:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:53962 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3COFOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:14:49 -0400
X-Spam-Score: -100.8
Message-ID: <5142AE27.7060003@asianux.com>
Date: Fri, 15 Mar 2013 13:14:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: sfr@canb.auug.org.au, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com>
In-Reply-To: <25841.1363323174@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月15日 12:52, Michael Neuling 写道:
> Yep it's a known problem but no one has bothered to fix it since it
> doesn't happen in a config that anyone cares about like
> pseries_defconfig and ppc64_defconfig.  We've been moving code around in
> this area a lot recently hence the breakage.
> 
> It should be fixed though.  Patches welcome. :-)

  thanks, and I should try, and very glad to try.

  :-)  :-)

  excuse me, I try to provide related patch within this month (2013-03-31), is it ok ?
  the reason is:
    I am not familiar with ppc assembly code, neither ppc kernel,
    so need additional time resource.
      (originally, I worked for x86(_64) core dump analysing for kernel and user programs)

  thanks.

-- 
Chen Gang

Asianux Corporation
