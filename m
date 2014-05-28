Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaE1UJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:09:39 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:51766 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaE1UJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:09:38 -0400
Date: Wed, 28 May 2014 23:09:29 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Li Zefan <lizefan@huawei.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, ralf@linux-mips.org,
        huawei.libin@huawei.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH V2] MIPS: change type of asid_cache to unsigned long
Message-ID: <20140528200929.GA30528@drone.musicnaut.iki.fi>
References: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com>
 <5384119E.7010606@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384119E.7010606@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 27, 2014 at 12:16:30PM +0800, Li Zefan wrote:
> On 2014/5/21 13:36, Yong Zhang wrote:
> > asid_cache must be unsigned long otherwise on 64bit system
> > it will become 0 if the value in get_new_mmu_context()
> > reaches 0xffffffff and in the end the assumption of
> > ASID_FIRST_VERSION is not true anymore thus leads to
> > more dangerous things.
> 
> We should describe what problem this bug can lead to, which
> will help people who encounter the same problem and google it.

Please describe it, then. Even if the patch is already committed,
googling would probably still find this e-mail thread.

Thanks,

A.
