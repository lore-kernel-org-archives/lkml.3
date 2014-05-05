Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaEERra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:47:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEERr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:47:28 -0400
Message-ID: <5367CE9E.5010208@oracle.com>
Date: Mon, 05 May 2014 13:47:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
CC: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on blkcg_pol_mutex
 in blkcg_reset_stats()
References: <5363C04B.4010400@oracle.com> <20140505163730.GL11231@htj.dyndns.org>
In-Reply-To: <20140505163730.GL11231@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun,

On 05/05/2014 12:37 PM, Tejun Heo wrote:
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>
> References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com

I think that the Reported-by here should be me :)


Thanks,
Sasha
