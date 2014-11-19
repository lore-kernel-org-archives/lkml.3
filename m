Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaKSPsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:48:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbaKSPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:48:22 -0500
Date: Wed, 19 Nov 2014 15:48:10 +0000
From: Mel Gorman <mgorman@suse.de>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [mm] kernel BUG at fs/xfs/xfs_aops.c:1069!
Message-ID: <20141119154810.GJ2725@suse.de>
References: <20141119021710.GD3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20141119021710.GD3938@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:17:10AM +0800, Yuanhan Liu wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma mm-numa-protnone-v1r7
> commit 5733e3f48a1f2c9ea4eb1eba38c06f65a48891a4 ("mm: Convert p[te|md]_mknonnuma and remaining page table manipulations")
> 

Thanks. This is very similar to the bug that Sasha reported so I'm
hoping the fix for that will fix this one too. FWIW, I have pushed a
branch called mm-numa-protnone-v2r5 to the same tree and I'm currently
testing it as a release candidate.

-- 
Mel Gorman
SUSE Labs
