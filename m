Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab3GaAU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:20:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:34313 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3GaAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,782,1367996400"; 
   d="scan'208";a="373725562"
Date: Wed, 31 Jul 2013 02:20:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mfd: Patches due for the v3.12 merge window
Message-ID: <20130731002022.GA20812@zurbaran>
References: <CAF2Aj3j2z=Pd-uW_VL6P=JMeEWnkf8aierMHb5Y6bv+y-GDiMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF2Aj3j2z=Pd-uW_VL6P=JMeEWnkf8aierMHb5Y6bv+y-GDiMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jul 30, 2013 at 01:28:02PM +0100, Lee Jones wrote:
> The following changes since commit 7b9f21e6a4051bb470d62b0601501376f9fc7db7:
> 
>   Merge tag 'mfd-3.11-1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next into
> mfd-3.11-merge (2013-07-08 23:52:21 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.linaro.org/people/ljones/mfd.git for-mfd-next
> 
> for you to fetch changes up to 50ef27e35c4fd91d40174a8bfd8220881376733e:
> 
>   mfd: ucb1x00: Explicitely include linux/device.h (2013-07-24 13:28:29 +0100)
I tried to pull those ones on top of a 3.11-rc3 tag and I had a merge
conflict.
So I rebased and applied them on top of 3.11-rc3 instead. Thanks a
bunch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
