Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109Ab3DHJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:19:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:47157 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934766Ab3DHJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="282925662"
Date: Mon, 8 Apr 2013 11:18:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: cbouatmailru@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AB8500 Power and MFD related updates
Message-ID: <20130408091851.GI24058@zurbaran>
References: <20130307043859.GA11944@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307043859.GA11944@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, Mar 07, 2013 at 12:38:59PM +0800, Lee Jones wrote:
> The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:
> 
>   Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd-and-power
I was expecting to get an MFD only branch (Basically what your for-mfd branch
looks like, and then the for-mfd-and-power one to be based on the mfd only
with the power patches applied on top of it.
Now, I have to pull the power patches as well, which is no big deal but not
ideal neither.
Anyway, I pulled this branch into mfd-next, with a tiny conflict.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
