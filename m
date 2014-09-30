Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaI3IQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:16:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaI3IQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:16:39 -0400
Date: Tue, 30 Sep 2014 10:16:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Please backport commit 3812c8c8f39 to stable
Message-ID: <20140930081637.GA4456@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-09-14 20:43:46, Cong Wang wrote:
> Hi, Johannes and Greg
> 
> 
> Please consider to backport the following commit to stable kernels < 3.12.
> 
> commit 3812c8c8f3953921ef18544110dafc3505c1ac62
> Author: Johannes Weiner <hannes@cmpxchg.org>
> Date:   Thu Sep 12 15:13:44 2013 -0700
> 
>     mm: memcg: do not trap chargers with full callstack on OOM
>
> It should solve some soft lockup I observed on different machines
> recently. For me myself, I only care about 3.10. :-p

Could you be more specific about the soft lockup you are seeing?
-- 
Michal Hocko
SUSE Labs
