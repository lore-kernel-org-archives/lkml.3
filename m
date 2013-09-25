Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3IYMLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:11:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55353 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684Ab3IYMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:11:24 -0400
Date: Wed, 25 Sep 2013 13:11:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org,
        grant.likely@linaro.org, msalter@redhat.com
Subject: Re: [PATCH V5 00/18] ARM EFI stub common code
Message-ID: <20130925121120.GI21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep, at 03:45:24PM, Roy Franz wrote:
> This patch is the common/x86 portion of the ARM EFI stub
> patchset broken out.  These changes support the addition
> of EFI stub support for the ARM and ARM64 architectures.
> The common code that is now shared in efi-stub-helper.c
> is based on code in the x86 stub that has been generalized
> to support other architectures.

OK, I've applied this patch series (excluding PATCH 10) to the
'arm/common' branch in the EFI repository at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

At the request of Grant, the patches series from both Roy and Leif are
available in a clean branch with a linear history at 'efi-arm', which is
based on v3.11. Grant, feel free to pull that branch into wherever it is
required. If this layout doesn't work for you guys then just shout and
we can come up with a scheme that does.

I'm going to send a pull request for the 'next' branch to the tip folks,
so that these patches can get some testing via linux-next.

-- 
Matt Fleming, Intel Open Source Technology Center
