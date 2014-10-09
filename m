Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaJIE4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:56:48 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:39471 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIE4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141007123334.GC14243@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
	<20140930081637.GA4456@dhcp22.suse.cz>
	<CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
	<CAM_iQpVC0Q0G9s-02nSqrmpGWL3G0bHLK41NoRfySAenoJc+uA@mail.gmail.com>
	<20141003153748.GF4816@dhcp22.suse.cz>
	<CAM_iQpVMGiE+gxbnr1x6QrSbDQGHAJGCEGMi9XAQCPbptA8j2A@mail.gmail.com>
	<20141007123334.GC14243@dhcp22.suse.cz>
Date: Wed, 8 Oct 2014 21:56:38 -0700
Message-ID: <CAM_iQpXA22Rn3YUpT27ZprabBAJXiju55z4FW3v3dnq0XO-2nw@mail.gmail.com>
Subject: Re: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 5:33 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 03-10-14 11:16:31, Cong Wang wrote:
>> I am sorry to confuse you that it is my the above test case which caused
>> this bug. No, we saw this bug in *production* in our data center, it happened
>> on 30+ machines!! :) The above insane test case is ONLY to draw your
>> attention on how serious the bug is, nothing else.
>
> Sure then the issue definitely needs to be fixed.
>
> You have written in other email, that you have a backport. I will help
> you with the review if you post it publicly.
>

Cool!

Note that I only have time to backport them to 3.10 and test on it.
Currently there are 8 patches backported to fix this bug, I am still
checking if we need more.

I will post them soon and Cc you of course.

Thanks for looking at it!
