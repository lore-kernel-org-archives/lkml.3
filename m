Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3IUI1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 04:27:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:32797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3IUI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 04:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,951,1371106800"; 
   d="scan'208";a="398990647"
Date: Sat, 21 Sep 2013 16:27:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Dont-Auto-Build
Message-ID: <20130921082710.GA30273@localhost>
References: <20130920143659.GA10591@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920143659.GA10591@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Fri, Sep 20, 2013 at 04:36:59PM +0200, Borislav Petkov wrote:
> Hey Fengguang,
> 
> do you still grep for "Dont-Auto-Build" in all the commit messages of a
> branch which is not supposed to be tested?

Yes.

> Or can I tag the branch name to make it more explicit for everyone?

If you name the branch *-experimental, it will be skipped by the robot.

Thanks,
Fengguang
