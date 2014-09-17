Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaIQPS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:18:59 -0400
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:48304 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbaIQPS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:18:57 -0400
Message-ID: <5419A656.2050004@mellanox.com>
Date: Wed, 17 Sep 2014 18:18:46 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Or Gerlitz <gerlitz.or@gmail.com>, Latchesar Ionkov <lionkov@lanl.gov>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>	<5405D2D8.1040700@mellanox.com>	<CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>	<CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com>	<CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>	<540F0CD8.9070002@mellanox.com> <CAJ3xEMhSZcrN0_nurc=-sUT+KM3vFgAD6XJjjA-eK0-Jyeut0Q@mail.gmail.com>
In-Reply-To: <CAJ3xEMhSZcrN0_nurc=-sUT+KM3vFgAD6XJjjA-eK0-Jyeut0Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.1.5.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/2014 12:16 AM, Or Gerlitz wrote:
> Per your request we provided the information on tests conducted with
> the patches.
>
> Note that the patches can't really disrupt existing applications that
> don't set the new IB_ACCESS_ON_DEMAND MR flag when they register
> memory. Also the whole set of changes to the umem area is dependent on building with
> CONFIG_INFINIBAND_ON_DEMAND_PAGING -- all in all, everything is in
> place for protecting against potential regression that this series
> could introduce.
>
> As you didn't provide any feedback for > six months, and we have all
> the above in place (report on stability tests, performance data and
> mechanics to avoid regressions) I think it would be fair to get this
> picked for the coming merge window, thoughts?

Roland,

Can you please comment here, not only that you didn't provide any 
feedback on the patches, you
are even not willing to respond if the the data we gave addresses your 
questions on testing and performance. Are you planning to pick this to 
the next merge window?

Or.
