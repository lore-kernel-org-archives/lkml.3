Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaJCUhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:37:00 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50829 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaJCUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVMGiE+gxbnr1x6QrSbDQGHAJGCEGMi9XAQCPbptA8j2A@mail.gmail.com>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
	<20140930081637.GA4456@dhcp22.suse.cz>
	<CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
	<CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
	<20141003153748.GF4816@dhcp22.suse.cz>
	<CAM_iQpVMGiE+gxbnr1x6QrSbDQGHAJGCEGMi9XAQCPbptA8j2A@mail.gmail.com>
Date: Fri, 3 Oct 2014 13:36:56 -0700
Message-ID: <CAM_iQpXappi5bnj=QriLxuhxdQ4=et3pHa7hUkLFjD_+D_bfKQ@mail.gmail.com>
Subject: Re: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 11:16 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Why not? OOM killer tries to kill a process sleeping on a mutex it already
> holds, why not a deadlock? Given the fact that both are lots of inode mutex
> hung because of OOM, I am 90% sure they are the same.
>

I backported these patches to 3.10 and can't reproduce the bug with the
script any more.
