Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3KYBVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:21:14 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:23363 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3KYBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:21:12 -0500
Message-ID: <5292A5EA.1030501@huawei.com>
Date: Mon, 25 Nov 2013 09:20:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: William Dauchy <wdauchy@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com> <20131122221839.GD8981@mtj.dyndns.org> <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
In-Reply-To: <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/23 6:54, William Dauchy wrote:
> Hi Tejun,
> 
> On Fri, Nov 22, 2013 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
>> Just applied to cgroup/for-3.13-fixes w/ stable cc'd.  Will push to
>> Linus next week.
> 
> Thank your for your quick reply. Do you also have a backport for
> v3.10.x already available?
> 

I'll do this after the patch hits mainline, if Tejun doesn't plan to.

