Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaE0QZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:25:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaE0QZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:25:41 -0400
Message-ID: <1401207939.5731.12.camel@tucsk.piliscsaba.szeredi.hu>
Subject: Re: [vfs] 662aa027bda: -7.2% will-it-scale.scalability
From: Miklos Szeredi <mszeredi@suse.cz>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Date: Tue, 27 May 2014 18:25:39 +0200
In-Reply-To: <5384B634.7080902@intel.com>
References: <5384B634.7080902@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 23:58 +0800, Jet Chen wrote:
> Hi Miklos,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v22
> commit 662aa027bdaa082aa3dd21886830c97a1dd4c184 ("vfs: add RENAME_WHITEOUT")
> 
> test case: lkp-wsx01/will-it-scale/lseek2

The only thing I see in that commit that could affect performance is the
slightly larger icache footprint of ext4_rename().

Is the regression reproducible across different -rc versions?

Thanks,
Miklos

