Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaHTFWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:22:24 -0400
Received: from trent.utfs.org ([94.185.90.103]:56990 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaHTFWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:22:23 -0400
Date: Tue, 19 Aug 2014 22:22:11 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: WARNING: CPU: 6 PID: 79 at fs/proc/generic.c:521
 remove_proc_entry+0x170/0x180()
In-Reply-To: <CAM_iQpWMtakj2QUEsF3NdzHyD-VULCkgMR4yf5VrPPBm03joEg@mail.gmail.com>
Message-ID: <alpine.DEB.2.19.4.1408192221430.2758@trent.utfs.org>
References: <alpine.DEB.2.19.4.1408191754390.2758@trent.utfs.org> <53F40CF8.8050504@linux.intel.com> <CAM_iQpWMtakj2QUEsF3NdzHyD-VULCkgMR4yf5VrPPBm03joEg@mail.gmail.com>
User-Agent: Alpine 2.19.4 (DEB 40 2013-11-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1 at Wed Aug 20 07:22:11 2014 +0200 (CEST))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014 at 20:13, Cong Wang wrote:
> On Tue, Aug 19, 2014 at 7:50 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> > Hi Kujau,
> >         It seems like a different issue, something wrong with
> > void nfs_fs_proc_net_exit(struct net *net)
> 
> http://marc.info/?l=linux-nfs&m=140821782107427&w=2

Thanks, that helped!

Christian.
-- 
BOFH excuse #182:

endothermal recalibration
