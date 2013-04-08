Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147Ab3DHJWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:22:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:55270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484Ab3DHJWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="318944578"
Date: Mon, 8 Apr 2013 11:22:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20130408092243.GK24058@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
 <1365396351.542317232@f36.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365396351.542317232@f36.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Apr 08, 2013 at 08:45:51AM +0400, Alexander Shiyan wrote:
> Hello.
> 
> > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> > drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> > 
> > Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> > 
> > I have used the mfd tree from next-20130405 for today.
> 
> This means that we do not have empty declarations for the
> of_xx functions in linux/of.h for !CONFIG_OF.
> OK to declare these functions or any other opinions?
Ok with me, but you'd need to get Grant and Rob's ACK.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
